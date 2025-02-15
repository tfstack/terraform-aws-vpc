locals {
  name   = "vpc-test"
  region = "ap-southeast-1"
}

data "http" "my_public_ip" {
  url = "http://ifconfig.me/ip"
}

data "aws_availability_zones" "available" {}

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

provider "aws" {
  region = "ap-southeast-1"
}

module "aws_vpc" {
  source = "../.."

  region             = local.region
  vpc_name           = local.name
  vpc_cidr           = "10.0.0.0/16"
  availability_zones = data.aws_availability_zones.available.names

  private_subnets = ["10.0.4.0/24"]

  eic_subnet = "private" # "jumphost"

  jumphost_instance_create = true
  jumphost_subnet          = "10.0.0.0/24"

  create_igw = true
  ngw_type   = "single"
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
