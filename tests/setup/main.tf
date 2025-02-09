terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

# Generate a random suffix for resource naming
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "aws_iam_policy" "jumphost_kafka_policy" {
  name        = "JumphostKafkaPolicy-${random_string.suffix.result}"
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

output "suffix" {
  value = random_string.suffix.result
}

output "cloud_init_yaml" {
  value = "${path.module}/external/cloud-init.yaml"
}

output "cloud_init_yaml_tpl" {
  value = "${path.module}/external/cloud-init.yaml.tpl"
}

output "jumphost_inline_policy_arns" {
  value = [aws_iam_policy.jumphost_kafka_policy.arn]
}
