# Retrieve your public ip
data "http" "my_public_ip" {
  url = "http://ifconfig.me/ip"
}

data "aws_availability_zones" "available" {}

provider "aws" {
  region = "ap-southeast-1"
}

locals {
  name = "demo"
}

module "aws_vpc" {
  source = "../.."

  region             = "ap-southeast-1"
  vpc_name           = local.name
  vpc_cidr           = "10.0.0.0/16"
  availability_zones = data.aws_availability_zones.available.names

  public_subnets = ["10.0.1.0/24"]

  eic_subnet        = "jumphost"
  eic_ingress_cidrs = ["${data.http.my_public_ip.response_body}/32"]

  jumphost_subnet          = "10.0.0.0/24"
  jumphost_instance_type   = "t3.micro"
  jumphost_allow_egress    = true
  jumphost_instance_create = true

  jumphost_user_data = <<-EOF
    #!/bin/bash
    hostnamectl set-hostname jumphost
  EOF

  # jumphost_user_data = <<-EOF
  #   #cloud-config
  #   runcmd:
  #     - hostnamectl set-hostname jumphost
  # EOF

  jumphost_log_retention_days  = 1
  jumphost_log_prevent_destroy = false

  create_igw = true
  ngw_type   = "single"

  tags = {
    Environment = "dev"
    Project     = "example"
  }
}

# Outputs
output "all_module_outputs" {
  description = "All outputs from the VPC module"
  value       = module.aws_vpc
}
