# Run setup to create a VPC
run "setup_vpc" {
  module {
    source = "./tests/setup"
  }
}

#Jumphost IAM Role and Policy Attachments
run "test_jumphost_iam_policies" {
  variables {
    vpc_name           = "test-vpc-${run.setup_vpc.suffix}"
    vpc_cidr           = "10.0.0.0/16"
    availability_zones = ["ap-southeast-1a"]
    jumphost_subnet    = "10.0.0.0/24"

    jumphost_iam_role_arns = [
      "arn:aws:iam::aws:role/AWSServiceRoleForAutoScaling"
    ]
    jumphost_inline_policy_arns = flatten(run.setup_vpc.jumphost_inline_policy_arns)
  }

  #Ensure the Jumphost IAM Role is Created
  assert {
    condition     = length(aws_iam_role.jumphost[*]) == 1
    error_message = "Jumphost IAM role was not created."
  }

  #Ensure the Correct Number of IAM Role Policy Attachments
  assert {
    condition     = length(aws_iam_role_policy_attachment.jumphost) == length(var.jumphost_iam_role_arns) + length(var.jumphost_inline_policy_arns)
    error_message = "Expected IAM role policy attachments (${length(var.jumphost_iam_role_arns) + length(var.jumphost_inline_policy_arns)}), but found ${length(aws_iam_role_policy_attachment.jumphost)}."
  }

  assert {
    condition     = contains([for p in tolist(aws_iam_role_policy_attachment.jumphost) : p.policy_arn], run.setup_vpc.jumphost_inline_policy_arns[0])
    error_message = "Jumphost IAM role is missing expected inline policy. Found: ${join(", ", [for p in aws_iam_role_policy_attachment.jumphost : p.policy_arn])}"
  }
}
