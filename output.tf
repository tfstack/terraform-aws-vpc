output "region" {
  value = data.aws_region.current.name
}

output "vpc_id" {
  value = aws_vpc.this.id
}

output "vpc_cidr" {
  value = aws_vpc.this.cidr_block
}

output "internet_gateway_id" {
  value = var.create_igw ? aws_internet_gateway.this[0].id : null
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "isolated_subnet_ids" {
  value = aws_subnet.isolated[*].id
}

output "database_subnet_ids" {
  value = aws_subnet.database[*].id
}

output "jumphost_subnet_id" {
  value = length(aws_subnet.jumphost) > 0 ? aws_subnet.jumphost[0].id : null
}

output "nat_gateway_ids" {
  value = length(aws_nat_gateway.this) > 0 ? aws_nat_gateway.this[*].id : []
}

output "eip_allocations" {
  value = length(aws_eip.this) > 0 ? aws_eip.this[*].id : []
}

output "route_table_public_ids" {
  value = aws_route_table.public[*].id
}

output "route_table_private_ids" {
  value = length(aws_route_table.private) > 0 ? aws_route_table.private[*].id : []
}

output "eic_security_group_id" {
  value = length(aws_security_group.eic) > 0 ? aws_security_group.eic[0].id : ""
}

output "jumphost_instance_id" {
  value = length(aws_instance.jumphost) > 0 ? aws_instance.jumphost[0].id : null
}

output "eic_endpoint_id" {
  value = length(aws_ec2_instance_connect_endpoint.this) > 0 ? aws_ec2_instance_connect_endpoint.this[0].id : null
}
