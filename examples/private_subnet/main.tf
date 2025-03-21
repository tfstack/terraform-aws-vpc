locals {
  name = "vpc-test"
}

data "http" "my_public_ip" {
  url = "http://ifconfig.me/ip"
}

data "aws_availability_zones" "available" {}

provider "aws" {
  region = "ap-southeast-1"
}

module "aws_vpc" {
  source = "../.."

  vpc_name           = local.name
  vpc_cidr           = "10.0.0.0/16"
  availability_zones = data.aws_availability_zones.available.names

  private_subnets = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

  eic_private_subnet = "10.0.5.0/24"
  eic_subnet         = "private"

  jumphost_instance_create = true
  jumphost_subnet          = "10.0.0.0/24"

  create_igw = true
  ngw_type   = "single"

  tags = {
    Environment = "dev"
    Project     = "example"
  }

  enable_eks_tags = false
}

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

resource "aws_instance" "private1" {
  ami                    = data.aws_ami.amzn2023.id
  instance_type          = "t3.micro"
  subnet_id              = module.aws_vpc.private_subnet_ids[0]
  vpc_security_group_ids = [module.aws_vpc.eic_security_group_id]

  tags = {
    Name = "${local.name}-private1"
  }
}

resource "aws_instance" "private2" {
  ami                    = data.aws_ami.amzn2023.id
  instance_type          = "t3.micro"
  subnet_id              = module.aws_vpc.private_subnet_ids[1]
  vpc_security_group_ids = [module.aws_vpc.eic_security_group_id]

  tags = {
    Name = "${local.name}-private2"
  }
}

resource "aws_instance" "private3" {
  ami                    = data.aws_ami.amzn2023.id
  instance_type          = "t3.micro"
  subnet_id              = module.aws_vpc.private_subnet_ids[2]
  vpc_security_group_ids = [module.aws_vpc.eic_security_group_id]

  tags = {
    Name = "${local.name}-private3"
  }
}
