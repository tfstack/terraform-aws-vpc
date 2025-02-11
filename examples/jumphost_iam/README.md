# **Terraform Module: AWS VPC with Jumphost IAM Configuration**

## **Overview**

This Terraform module provisions an AWS VPC with a **jumphost** that has controlled IAM role and policy assignments. The jumphost is configured with:

- **IAM Roles (`jumphost_iam_role_arns`)** – Attach existing IAM roles to the jumphost.
- **IAM Inline Policies (`jumphost_inline_policy_arns`)** – Attach custom inline policies for fine-grained permissions.

This ensures the jumphost can securely interact with AWS services such as Kafka, Secrets Manager, and KMS.

## **IAM Configuration**

### **1. Using Pre-Existing IAM Roles**

You can attach existing AWS IAM roles to the jumphost using the `jumphost_iam_role_arns` variable. This is useful when you have predefined roles with specific permissions.

```hcl
module "aws_vpc" {
  source = "../.."

  region             = "ap-southeast-1"
  vpc_name           = "demo"
  vpc_cidr           = "10.0.0.0/16"
  availability_zones = data.aws_availability_zones.available.names

  jumphost_subnet = "10.0.0.0/24"
  jumphost_iam_role_arns = [
    "arn:aws:iam::aws:role/AWSServiceRoleForAutoScaling",
  ]

  create_igw = false
  ngw_type   = "none"

  tags = {
    Environment = "dev"
    Project     = "example"
  }
}
```

---

### **2. Attaching Custom Inline IAM Policies**

If you need to grant specific permissions to the jumphost, you can define an **inline IAM policy** and attach it using `jumphost_inline_policy_arns`.

#### **Define an Inline Policy for Kafka & Secrets Manager**

```hcl
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
```

#### **Attach the Policy to the Jumphost**

```hcl
module "aws_vpc" {
  source = "../.."

  jumphost_inline_policy_arns = [
    aws_iam_policy.jumphost_kafka_policy.arn
  ]
}
```

---

### **3. Combining IAM Roles and Inline Policies**

You can **combine IAM roles and inline policies** to apply both predefined AWS permissions and custom security policies.

```hcl
module "aws_vpc" {
  source = "../.."

  jumphost_iam_role_arns = [
    "arn:aws:iam::aws:role/AWSServiceRoleForAutoScaling",
  ]

  jumphost_inline_policy_arns = [
    aws_iam_policy.jumphost_kafka_policy.arn
  ]
}
```

---

## **Requirements**

- Terraform >= 1.0.0
- AWS Provider >= 4.0
- IAM permissions to attach roles and policies

## **License**

MIT License
