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

output "suffix" {
  value = random_string.suffix.result
}
