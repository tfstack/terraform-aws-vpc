# **Test: Jumphost User Data Configuration**

## **Run setup to create a VPC**
run "setup_vpc" {
  module {
    source = "./tests/setup"
  }
}

## **Test Inline User Data**
run "test_jumphost_inline_userdata" {
  variables {
    vpc_name                     = "test-vpc-${run.setup_vpc.suffix}"
    vpc_cidr                     = "10.0.0.0/16"
    availability_zones           = ["ap-southeast-1a"]
    jumphost_subnet              = "10.0.0.0/24"
    jumphost_allow_egress        = true
    jumphost_log_prevent_destroy = false

    jumphost_user_data = <<-EOF
      #!/bin/bash
      echo "Jumphost initialized" > /etc/motd
    EOF
  }

  assert {
    condition     = length(aws_instance.jumphost) == 1
    error_message = "Jumphost EC2 instance was not created."
  }

  assert {
    condition     = aws_instance.jumphost[0].user_data_base64 != null
    error_message = "Jumphost EC2 instance does not have user data applied."
  }
}
