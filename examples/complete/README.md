# Terraform Module: AWS VPC Setup

## Overview

This Terraform module provisions an AWS VPC along with public, private, isolated, and database subnets. It also sets up a jump host with ingress rules restricted to the user's public IP.

## Usage

```hcl
# Retrieve your public IP
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

  jumphost_subnet        = "10.0.0.0/24"
  jumphost_ingress_cidrs = ["${data.http.my_public_ip.response_body}/32"]
  jumphost_instance_type = "t3.micro"
  jumphost_allow_egress  = true

  create_igw = true
  ngw_type   = "single"

  tags = {
    Environment = "dev"
    Project     = "example"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `region` | AWS region for the provider. Defaults to `ap-southeast-2` if not specified. | `string` | `ap-southeast-2` | ❌ |
| `vpc_name` | The name of the VPC | `string` | n/a | ✅ |
| `vpc_cidr` | CIDR block for the VPC | `string` | n/a | ✅ |
| `availability_zones` | List of availability zones | `list(string)` | `[...]` | ✅ |
| `public_subnets` | List of CIDR blocks for public subnets | `list(string)` | `[]` | ❌ |
| `private_subnets` | List of CIDR blocks for private subnets | `list(string)` | `[]` | ❌ |
| `isolated_subnets` | List of CIDR blocks for isolated subnets | `list(string)` | `[]` | ❌ |
| `database_subnets` | List of CIDR blocks for database subnets | `list(string)` | `[]` | ❌ |
| `jumphost_subnet` | CIDR block for the jump host subnet. If empty, the subnet will not be created. | `string` | `""` | ❌ |
| `jumphost_ingress_cidrs` | List of CIDR blocks for allowed inbound SSH traffic to the jumphost | `list(string)` | `["0.0.0.0/0"]` | ❌ |
| `jumphost_instance_type` | The EC2 instance type for the jumphost | `string` | `t3.micro` | ❌ |
| `jumphost_allow_egress` | Whether to allow outbound internet access from the jumphost | `bool` | `false` | ❌ |
| `create_igw` | Whether to create an Internet Gateway (IGW) for public subnets | `bool` | `true` | ❌ |
| `ngw_type` | Specify `one_per_az` for high availability, `single` for cost-saving, or `none` to disable NAT Gateway | `string` | `none` | ❌ |
| `tags` | A map of tags to use on all resources | `map(string)` | `{}` | ❌ |

## Outputs

| Name | Description |
|------|-------------|
| `region` | AWS region being used |
| `vpc_id` | ID of the created VPC |
| `vpc_cidr` | CIDR block of the VPC |
| `internet_gateway_id` | Internet Gateway ID if created |
| `public_subnet_ids` | List of public subnet IDs |
| `private_subnet_ids` | List of private subnet IDs |
| `isolated_subnet_ids` | List of isolated subnet IDs |
| `database_subnet_ids` | List of database subnet IDs |
| `jumphost_subnet_id` | ID of the jumphost subnet if created |
| `nat_gateway_ids` | List of NAT Gateway IDs if created |
| `eip_allocations` | List of Elastic IP allocations if NAT is enabled |
| `route_table_public_ids` | List of public route table IDs |
| `route_table_private_ids` | List of private route table IDs if NAT is enabled |
| `route_table_jumphost_id` | ID of the jumphost route table if applicable |
| `jumphost_security_group_id` | Security group ID for the jumphost |
| `jumphost_instance_id` | ID of the jumphost instance if created |
| `ec2_instance_connect_endpoint_id` | EC2 Instance Connect Endpoint ID if applicable |

## Requirements

- Terraform >= 1.0.0
- AWS Provider >= 4.0

## License

MIT License
