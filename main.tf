# ===================================
# Data Sources
# ===================================
# Fetch AWS region dynamically
data "aws_region" "current" {}

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

# ===================================
# Local Variables
# ===================================
locals {
  name = var.vpc_name
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

  tags = {
    Name = "${local.name}-public-${count.index}"
  }
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

  tags = {
    Name = "${local.name}-private-${count.index}"
  }
}

resource "aws_route_table" "private" {
  count  = var.ngw_type != "none" ? length(var.private_subnets) : 0
  vpc_id = aws_vpc.this.id

  dynamic "route" {
    for_each = var.ngw_type != "none" ? [1] : []
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

resource "aws_route_table" "jumphost" {
  count = (
    var.jumphost_subnet != "" &&
    var.jumphost_allow_egress &&
    var.ngw_type != "none" &&
    length(aws_nat_gateway.this) > 0
  ) ? 1 : 0

  vpc_id = aws_vpc.this.id

  dynamic "route" {
    for_each = var.ngw_type != "none" ? [1] : []
    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.this[var.ngw_type == "one_per_az" ? count.index : 0].id
    }
  }

  tags = {
    Name = "${local.name}-jumphost"
  }
}

resource "aws_route_table_association" "jumphost" {
  count = (
    var.jumphost_subnet != "" &&
    var.jumphost_allow_egress &&
    var.ngw_type != "none" &&
    length(aws_route_table.jumphost) > 0
  ) ? 1 : 0

  subnet_id      = aws_subnet.jumphost[0].id
  route_table_id = aws_route_table.jumphost[0].id
}

resource "aws_security_group" "jumphost" {
  count = var.jumphost_subnet != "" ? 1 : 0

  vpc_id = aws_vpc.this.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.jumphost_ingress_cidrs
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
# EC2 Instance Connect Endpoint (For Jumphost)
# ===================================
resource "aws_ec2_instance_connect_endpoint" "this" {
  count = var.jumphost_subnet != "" ? 1 : 0

  subnet_id          = aws_subnet.jumphost[0].id
  security_group_ids = [aws_security_group.jumphost[0].id]

  tags = {
    Name = "${local.name}-instance-connect"
  }
}

# ===================================
# Jumphost EC2 Instance
# ===================================
resource "aws_instance" "jumphost" {
  count = var.jumphost_subnet != "" ? 1 : 0

  ami           = data.aws_ami.amzn2023.id
  instance_type = var.jumphost_instance_type
  subnet_id     = aws_subnet.jumphost[0].id

  user_data = <<-EOF
    #!/bin/bash
    hostnamectl set-hostname jumphost
  EOF

  vpc_security_group_ids = [
    aws_security_group.jumphost[0].id
  ]

  tags = {
    Name = "${local.name}-jumphost"
  }
}
