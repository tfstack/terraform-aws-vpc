locals {
  name   = "vpc-test"
  region = "ap-southeast-1"
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

  region             = local.region
  vpc_name           = local.name
  vpc_cidr           = "10.0.0.0/16"
  availability_zones = data.aws_availability_zones.available.names

  private_subnets = ["10.0.4.0/24"]

  jumphost_instance_create = false

  create_igw = true
  ngw_type   = "single"
}
