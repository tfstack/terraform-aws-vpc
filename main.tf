# ===================================
# Data Sources
# ===================================
# Fetch AWS region dynamically
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

# Fetch Latest Amazon Linux 2023 AMI for Jumphost
data "aws_ami" "amzn2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "name"
    values = ["al2023-ami-2023*"]
  }
}

data "aws_security_group" "default" {
  filter {
    name   = "group-name"
    values = ["default"]
  }

  vpc_id = aws_vpc.this.id
}

# ===================================
# Local Variables
# ===================================
locals {
  name = var.vpc_name

  # Get user data from variable, file, or template
  user_data = (
    var.jumphost_user_data != null && var.jumphost_user_data != "" ? var.jumphost_user_data :
    var.jumphost_user_data_file != null && var.jumphost_user_data_file != "" ? file(var.jumphost_user_data_file) :
    var.jumphost_user_data_template != null && var.jumphost_user_data_template != "" ? templatefile(var.jumphost_user_data_template, var.jumphost_user_data_template_vars) :
    ""
  )

  cloudwatch_user_data = (
    templatefile("${path.module}/external/cloudwatch-agent.sh.tpl", { aws_region = data.aws_region.current.name })
  )

  # Ensure private subnet selection is always valid
  private_subnet_map     = length(aws_subnet.private) > 0 ? zipmap(var.private_subnets, aws_subnet.private[*].id) : {}
  default_private_subnet = length(var.private_subnets) > 0 ? var.private_subnets[0] : null

  selected_private_subnet = var.eic_private_subnet != "" ? var.eic_private_subnet : local.default_private_subnet

  eic_subnet_id = (
    var.eic_subnet == "jumphost" ? aws_subnet.jumphost[0].id :
    var.eic_subnet == "private" ? lookup(local.private_subnet_map, local.selected_private_subnet, null) :
    null
  )
}

data "template_file" "user_data" {
  template = file("${path.module}/external/cloud-init-main.yaml.tpl")

  vars = {
    user_data            = local.user_data
    cloudwatch_user_data = local.cloudwatch_user_data
  }
}

# ===================================
# VPC Configuration
# ===================================
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name
  }
}

# ===================================
# Internet Gateway
# ===================================
resource "aws_internet_gateway" "this" {
  count  = var.create_igw ? 1 : 0
  vpc_id = aws_vpc.this.id

  tags = {
    Name = local.name
  }
}

# ===================================
# Public Subnets
# ===================================
resource "aws_subnet" "public" {
  count = length(var.public_subnets)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnets[count.index]
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zones[count.index]

  tags = merge(
    {
      Name = "${local.name}-public-${count.index}"
    },
    var.enable_eks_tags ? {
      "kubernetes.io/role/elb"                        = "1"
      "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
    } : {}
  )
}

resource "aws_route_table" "public" {
  count  = length(var.public_subnets)
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.create_igw ? aws_internet_gateway.this[0].id : null
  }

  tags = {
    Name = "${local.name}-public-${count.index}"
  }
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnets)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[count.index].id
}

# ===================================
# NAT Gateway & EIP (For Private Subnets)
# ===================================
resource "aws_eip" "this" {
  count  = var.ngw_type != "none" ? (var.ngw_type == "one_per_az" ? length(var.availability_zones) : 1) : 0
  domain = "vpc"

  tags = {
    Name = local.name
  }
}

resource "aws_nat_gateway" "this" {
  count = (
    var.ngw_type != "none" && length(var.public_subnets) > 0 ?
    (var.ngw_type == "one_per_az" ? length(var.availability_zones) : 1) : 0
  )

  allocation_id = aws_eip.this[count.index].id
  subnet_id     = aws_subnet.public[count.index % length(var.public_subnets)].id

  tags = {
    Name = "${local.name}-${count.index}"
  }

  depends_on = [
    aws_internet_gateway.this
  ]
}

# ===================================
# Private Subnets
# ===================================
resource "aws_subnet" "private" {
  count = length(var.private_subnets)

  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = merge(
    {
      Name = "${local.name}-private-${count.index}"
    },
    var.enable_eks_tags ? {
      "kubernetes.io/role/internal-elb"               = "1"
      "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
    } : {}
  )
}

resource "aws_route_table" "private" {
  count  = var.ngw_type != "none" ? length(var.private_subnets) : 0
  vpc_id = aws_vpc.this.id

  dynamic "route" {
    for_each = var.ngw_type != "none" && length(aws_nat_gateway.this) > 0 ? [1] : []
    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.this[var.ngw_type == "one_per_az" ? count.index : 0].id
    }
  }

  tags = {
    Name = "${local.name}-private-${count.index}"
  }
}

resource "aws_route_table_association" "private" {
  count = var.ngw_type != "none" ? length(var.private_subnets) : 0

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

# ===================================
# Isolated Subnets (No Internet Access)
# ===================================
resource "aws_subnet" "isolated" {
  count = length(var.isolated_subnets)

  vpc_id            = aws_vpc.this.id
  cidr_block        = var.isolated_subnets[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${local.name}-isolated-${count.index}"
  }
}

resource "aws_route_table" "isolated" {
  count  = var.enable_s3_vpc_endpoint ? length(var.isolated_subnets) : 0
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${local.name}-isolated-${count.index}"
  }
}

resource "aws_route_table_association" "isolated" {
  count = var.enable_s3_vpc_endpoint ? length(var.isolated_subnets) : 0

  subnet_id      = aws_subnet.isolated[count.index].id
  route_table_id = aws_route_table.isolated[count.index].id
}

# ===================================
# Database Subnets
# ===================================
resource "aws_subnet" "database" {
  count = length(var.database_subnets)

  vpc_id            = aws_vpc.this.id
  cidr_block        = var.database_subnets[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${local.name}-database-${count.index}"
  }
}

resource "aws_route_table" "database" {
  count  = var.enable_s3_vpc_endpoint ? length(var.database_subnets) : 0
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${local.name}-database-${count.index}"
  }
}

resource "aws_route_table_association" "database" {
  count = var.enable_s3_vpc_endpoint ? length(var.database_subnets) : 0

  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database[count.index].id
}

# ===================================
# Jumphost Subnet & Security Group
# ===================================
resource "aws_subnet" "jumphost" {
  count = var.jumphost_subnet != "" ? 1 : 0

  vpc_id            = aws_vpc.this.id
  cidr_block        = var.jumphost_subnet
  availability_zone = var.availability_zones[0]

  tags = {
    Name = "${local.name}-jumphost"
  }
}

# resource "aws_route_table" "jumphost" {
#   count = (
#     var.jumphost_subnet != "" &&
#     (var.jumphost_allow_egress || var.enable_s3_vpc_endpoint) &&
#     var.ngw_type != "none" &&
#     length(aws_nat_gateway.this) > 0
#   ) ? 1 : 0

#   vpc_id = aws_vpc.this.id

#   dynamic "route" {
#     for_each = var.ngw_type != "none" ? [1] : []
#     content {
#       cidr_block     = "0.0.0.0/0"
#       nat_gateway_id = aws_nat_gateway.this[var.ngw_type == "one_per_az" ? count.index : 0].id
#     }
#   }

#   tags = {
#     Name = "${local.name}-jumphost"
#   }
# }

# resource "aws_route_table_association" "jumphost" {
#   count = (
#     var.jumphost_subnet != "" &&
#     (var.jumphost_allow_egress || var.enable_s3_vpc_endpoint) &&
#     var.ngw_type != "none" &&
#     length(aws_route_table.jumphost) > 0
#   ) ? 1 : 0

#   subnet_id      = aws_subnet.jumphost[0].id
#   route_table_id = aws_route_table.jumphost[0].id
# }

locals {
  create_jumphost_route_allow_egress = (
    var.jumphost_subnet != "" &&
    var.jumphost_allow_egress &&
    var.ngw_type != "none" &&
    length(aws_nat_gateway.this) > 0
  )
}

resource "aws_route_table" "jumphost_allow_egress" {
  count  = local.create_jumphost_route_allow_egress ? 1 : 0
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this[var.ngw_type == "one_per_az" ? count.index : 0].id
  }

  tags = {
    Name = "${local.name}-jumphost"
  }
}

resource "aws_route_table" "jumphost_no_egress" {
  count  = local.create_jumphost_route_allow_egress ? 0 : 1
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${local.name}-jumphost"
  }
}

resource "aws_route_table_association" "jumphost" {
  count = var.jumphost_subnet != "" ? 1 : 0

  subnet_id = aws_subnet.jumphost[0].id

  route_table_id = (
    local.create_jumphost_route_allow_egress ?
    aws_route_table.jumphost_allow_egress[0].id :
    aws_route_table.jumphost_no_egress[0].id
  )
}

resource "aws_security_group" "eic" {
  count = var.eic_subnet != "none" ? 1 : 0

  vpc_id = aws_vpc.this.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = length(var.eic_ingress_cidrs) > 0 ? var.eic_ingress_cidrs : var.jumphost_ingress_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.name}-jumphost"
  }
}

# ===================================
# EC2 Instance Connect Endpoint
# ===================================
resource "aws_ec2_instance_connect_endpoint" "this" {
  count = var.eic_subnet != "none" ? 1 : 0

  subnet_id          = local.eic_subnet_id
  security_group_ids = length(aws_security_group.eic) > 0 ? [aws_security_group.eic[0].id] : []

  tags = {
    Name = "${local.name}-instance-connect"
  }
}

# ===================================
# VPC Endpoints
# ===================================
resource "aws_vpc_endpoint" "s3" {
  count             = var.enable_s3_vpc_endpoint ? 1 : 0
  vpc_id            = aws_vpc.this.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = tolist(flatten(concat(
    try(aws_route_table.isolated[*].id, []),
    try(aws_route_table.database[*].id, []),
    try(aws_route_table.private[*].id, []),
    try(
      var.jumphost_subnet != "" ?
      (
        var.jumphost_allow_egress && var.ngw_type != "none" && length(aws_nat_gateway.this) > 0 ?
        [aws_route_table.jumphost_allow_egress[0].id] :
        [aws_route_table.jumphost_no_egress[0].id]
      ) : [],
      []
    )
  )))

  tags = {
    Name = "${local.name}-s3-endpoint"
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_route_table.jumphost_allow_egress,
    aws_route_table.jumphost_no_egress
  ]
}

# ===================================
# Jumphost EC2 Instance
# ===================================
module "iam_policy_chunker" {
  source = "tfstack/iam-policy-chunker/aws"

  resource_list      = var.jumphost_iam_role_arns
  actions            = ["sts:AssumeRole"]
  policy_name        = "${local.name}-jumphost"
  policy_description = "${local.name} IAM policy for jumphost"
  chunk_size         = 10
}

resource "aws_iam_role" "jumphost" {
  count = (
    length(module.iam_policy_chunker.policy_names) > 0 ||
    length(var.jumphost_inline_policy_arns) > 0 ||
    var.jumphost_instance_create
  ) ? 1 : 0

  name = "${local.name}-jumphost"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "jumphost_logging" {
  count = (
    length(aws_iam_role.jumphost) > 0 &&
    var.jumphost_instance_create
  ) ? 1 : 0

  name        = "${local.name}-jumphost-logging"
  description = "Allows EC2 jumphost to write logs only to its CloudWatch log group"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:DescribeLogStreams",
          "logs:PutLogEvents",
        ]
        Resource = (
          length(aws_cloudwatch_log_group.jumphost_with_prevent_destroy) > 0
          ? "${aws_cloudwatch_log_group.jumphost_with_prevent_destroy[0].arn}:log-stream:*"
          : "${aws_cloudwatch_log_group.jumphost_without_prevent_destroy[0].arn}:log-stream:*"
        )
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "jumphost_logging" {
  count = (
    length(aws_iam_role.jumphost) > 0 &&
    var.jumphost_instance_create
  ) ? 1 : 0

  role       = aws_iam_role.jumphost[0].name
  policy_arn = aws_iam_policy.jumphost_logging[0].arn
}

resource "aws_iam_role_policy_attachment" "jumphost" {
  count = length(module.iam_policy_chunker.policy_names) + length(var.jumphost_inline_policy_arns)

  role = aws_iam_role.jumphost[0].name
  policy_arn = (
    count.index < length(module.iam_policy_chunker.policy_names)
    ? "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/${module.iam_policy_chunker.policy_names[count.index]}"
    : var.jumphost_inline_policy_arns[count.index - length(module.iam_policy_chunker.policy_names)]
  )
}

resource "aws_iam_instance_profile" "jumphost" {
  count = (
    length(aws_iam_role.jumphost) > 0 &&
    var.jumphost_instance_create
  ) ? 1 : 0

  name = "${local.name}-jumphost"
  role = aws_iam_role.jumphost[0].name
}

resource "aws_instance" "jumphost" {
  count = (var.jumphost_subnet != "" && var.jumphost_instance_create) ? 1 : 0

  ami                  = data.aws_ami.amzn2023.id
  instance_type        = var.jumphost_instance_type
  iam_instance_profile = length(aws_iam_instance_profile.jumphost) > 0 ? aws_iam_instance_profile.jumphost[0].name : null
  subnet_id            = length(aws_subnet.jumphost) > 0 ? aws_subnet.jumphost[0].id : null

  user_data_base64 = base64encode(data.template_file.user_data.rendered)

  vpc_security_group_ids = (
    length(aws_security_group.eic) > 0 ?
    [aws_security_group.eic[0].id] :
    [data.aws_security_group.default.id]
  )

  tags = {
    Name = "${local.name}-jumphost"
  }
}

resource "aws_cloudwatch_log_group" "jumphost_with_prevent_destroy" {
  count = (var.jumphost_subnet != "" && var.jumphost_instance_create && var.jumphost_log_prevent_destroy) ? 1 : 0

  name              = length(aws_instance.jumphost) > 0 ? "/aws/ec2/${aws_instance.jumphost[0].id}" : "/aws/ec2/jumphost-placeholder"
  retention_in_days = var.jumphost_log_retention_days

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name = "${local.name}-jumphost"
  }
}

resource "aws_cloudwatch_log_group" "jumphost_without_prevent_destroy" {
  count = (var.jumphost_subnet != "" && var.jumphost_instance_create && !var.jumphost_log_prevent_destroy) ? 1 : 0

  name              = length(aws_instance.jumphost) > 0 ? "/aws/ec2/${aws_instance.jumphost[0].id}" : "/aws/ec2/jumphost-placeholder"
  retention_in_days = var.jumphost_log_retention_days

  lifecycle {
    prevent_destroy = false
  }

  tags = {
    Name = "${local.name}-jumphost"
  }
}
