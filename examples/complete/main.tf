# Retrieve your public ip
data "http" "my_public_ip" {
  url = "http://ifconfig.me/ip"
}

module "aws_vpc" {
  source = "../.."

  region             = "ap-southeast-1"
  vpc_name           = "vpc"
  vpc_cidr           = "10.0.0.0/16"
  availability_zones = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]

  public_subnets   = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets  = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  isolated_subnets = ["10.0.7.0/24", "10.0.8.0/24"]
  database_subnets = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]

  eic_ingress_cidrs      = ["${data.http.my_public_ip.response_body}/32"]
  jumphost_subnet        = "10.0.0.0/24"
  jumphost_instance_type = "t3.micro"
  jumphost_allow_egress  = true

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
