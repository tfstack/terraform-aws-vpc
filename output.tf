output "s3_vpc_endpoint_id" {
  description = "The ID of the S3 VPC Endpoint"
  value       = length(aws_vpc_endpoint.s3) > 0 ? aws_vpc_endpoint.s3[0].id : null
}

output "region" {
  description = "The current AWS region"
  value       = data.aws_region.current.region
}

output "vpc_id" {
  description = "The ID of the created VPC"
  value       = aws_vpc.this.id
}

output "vpc_cidr" {
  description = "The CIDR block of the created VPC"
  value       = aws_vpc.this.cidr_block
}

output "public_subnet_ids" {
  description = "IDs of all public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs of all private subnets"
  value       = aws_subnet.private[*].id
}

output "isolated_subnet_ids" {
  description = "IDs of all isolated subnets"
  value       = aws_subnet.isolated[*].id
}

output "database_subnet_ids" {
  description = "IDs of all database subnets"
  value       = aws_subnet.database[*].id
}

output "jumphost_subnet_id" {
  description = "ID of the jumphost subnet (if defined)"
  value       = length(aws_subnet.jumphost) > 0 ? aws_subnet.jumphost[0].id : null
}

output "public_subnet_cidrs" {
  description = "CIDR blocks of public subnets"
  value       = aws_subnet.public[*].cidr_block
}

output "private_subnet_cidrs" {
  description = "CIDR blocks of private subnets"
  value       = aws_subnet.private[*].cidr_block
}

output "isolated_subnet_cidrs" {
  description = "CIDR blocks of isolated subnets"
  value       = aws_subnet.isolated[*].cidr_block
}

output "database_subnet_cidrs" {
  description = "CIDR blocks of database subnets"
  value       = aws_subnet.database[*].cidr_block
}

output "jumphost_subnet_cidr" {
  description = "CIDR block of the jumphost subnet (if defined)"
  value       = aws_subnet.jumphost[*].cidr_block
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway (if created)"
  value       = var.create_igw ? aws_internet_gateway.this[0].id : null
}

output "nat_gateway_ids" {
  description = "List of NAT Gateway IDs (if created)"
  value       = length(aws_nat_gateway.this) > 0 ? aws_nat_gateway.this[*].id : []
}

output "eip_allocations" {
  description = "List of Elastic IP allocation IDs (if created)"
  value       = length(aws_eip.this) > 0 ? aws_eip.this[*].id : []
}

output "route_table_public_ids" {
  description = "IDs of public route tables"
  value       = aws_route_table.public[*].id
}

output "route_table_private_ids" {
  description = "IDs of private route tables"
  value       = length(aws_route_table.private) > 0 ? aws_route_table.private[*].id : []
}

output "eic_security_group_id" {
  description = "ID of the security group used by EC2 Instance Connect (EIC), if defined"
  value       = length(aws_security_group.eic) > 0 ? aws_security_group.eic[0].id : ""
}

output "jumphost_instance_id" {
  description = "ID of the jumphost EC2 instance (if created)"
  value       = length(aws_instance.jumphost) > 0 ? aws_instance.jumphost[0].id : null
}

output "eic_endpoint_id" {
  description = "ID of the EC2 Instance Connect Endpoint (if created)"
  value       = length(aws_ec2_instance_connect_endpoint.this) > 0 ? aws_ec2_instance_connect_endpoint.this[0].id : null
}
