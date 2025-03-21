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

resource "aws_iam_policy" "jumphost_kafka_policy" {
  name        = "JumphostKafkaPolicy"
  description = "Policy allowing Kafka and Secrets Manager access"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "kafka:*",
          "kafka-cluster:*",
          "secretsmanager:GetSecretValue",
          "kms:Decrypt"
        ],
        Resource = "*"
      }
    ]
  })
}

module "aws_vpc" {
  source = "../.."

  vpc_name           = local.name
  vpc_cidr           = "10.0.0.0/16"
  availability_zones = data.aws_availability_zones.available.names

  jumphost_subnet = "10.0.0.0/24"
  jumphost_iam_role_arns = [
    "arn:aws:iam::aws:role/AWSServiceRoleForAutoScaling",
  ]
  jumphost_inline_policy_arns = [
    aws_iam_policy.jumphost_kafka_policy.arn
  ]
  jumphost_log_prevent_destroy = false

  create_igw = false
  ngw_type   = "none"

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
