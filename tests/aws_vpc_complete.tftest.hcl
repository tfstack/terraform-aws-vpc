# Run setup to create a VPC
run "setup_vpc" {
  module {
    source = "./tests/setup"
  }
}

# Main test block to create and test the VPC, subnets, and NAT gateway
run "test_vpc_configuration" {
  variables {
    vpc_cidr   = "10.0.0.0/16"
    vpc_name   = "test-vpc-${run.setup_vpc.suffix}"
    create_igw = true
    public_subnets = [
      "10.0.1.0/24",
      "10.0.2.0/24"
    ]
    private_subnets = [
      "10.0.3.0/24",
      "10.0.4.0/24"
    ]
    isolated_subnets = [
      "10.0.5.0/24",
      "10.0.6.0/24"
    ]
    database_subnets = [
      "10.0.10.0/24",
      "10.0.11.0/24"
    ]
    availability_zones = ["ap-southeast-1a", "ap-southeast-1b"]
    ngw_type           = "one_per_az"

    jumphost_subnet       = "10.0.0.0/24"
    jumphost_allow_egress = true
  }

  # Assert that the created VPC ID matches the expected output
  assert {
    condition     = length(aws_vpc.this) > 0
    error_message = "VPC was not created as expected."
  }

  # Assert that the public subnets were created
  assert {
    condition     = length(aws_subnet.public) == 2
    error_message = "Expected 2 public subnets but found different count"
  }

  # Assert that the private subnets were created
  assert {
    condition     = length(aws_subnet.private) == 2
    error_message = "Expected 2 private subnets but found different count"
  }

  # Assert that the isolated subnets were created
  assert {
    condition     = length(aws_subnet.isolated) == 2
    error_message = "Expected 2 isolated subnets but found different count"
  }

  # Assert that the database subnets were created
  assert {
    condition     = length(aws_subnet.database) == 2
    error_message = "Expected 2 database subnets but found different count"
  }

  # Assert that NAT Gateway(s) were created
  assert {
    condition     = length(aws_nat_gateway.this) == 2
    error_message = "Expected one NAT Gateway per AZ, but count does not match"
  }

  # Assert that the Internet Gateway was created when enabled
  assert {
    condition     = aws_internet_gateway.this[0].id != null
    error_message = "Internet Gateway was not created as expected"
  }

  # Assert that the route table for public subnets contains a route to the Internet Gateway
  assert {
    condition = anytrue(flatten([
      for rt in aws_route_table.public : [
        for route in rt.route : route.cidr_block == "0.0.0.0/0" && route.gateway_id != null
      ]
    ]))
    error_message = "Public subnets are missing an Internet Gateway route"
  }

  # Assert that the route table for private subnets contains a route to a NAT Gateway
  assert {
    condition = anytrue(flatten([
      for rt in aws_route_table.private : [
        for route in rt.route : route.cidr_block == "0.0.0.0/0" && route.nat_gateway_id != null
      ]
    ]))
    error_message = "Private subnets are missing a NAT Gateway route"
  }

  # Assert that the route table for jumphost subnet contains a route to a NAT Gateway
  assert {
    condition = anytrue(flatten([
      for rt in aws_route_table.jumphost : [
        for route in rt.route : route.cidr_block == "0.0.0.0/0" && route.nat_gateway_id != null
      ]
    ]))
    error_message = "Jumphost subnets are missing a NAT Gateway route"
  }

  # Assert that EC2 Instance Connect Endpoint was created
  assert {
    condition     = length(aws_ec2_instance_connect_endpoint.this) == 1
    error_message = "Expects 1 EC2 Instance Connect Endpoint, but count does not match"
  }

  # Assert that Jumphost EC2 Instance was created
  assert {
    condition     = length(aws_instance.jumphost) == 1
    error_message = "Expects 1 Jumphost EC2 Instance, but count does not match"
  }
}
