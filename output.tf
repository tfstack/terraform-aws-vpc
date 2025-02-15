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
  value = var.jumphost_subnet != "" ? aws_subnet.jumphost[0].id : null
}

output "nat_gateway_ids" {
  value = var.ngw_type != "none" ? aws_nat_gateway.this[*].id : []
}

output "eip_allocations" {
  value = var.ngw_type != "none" ? aws_eip.this[*].id : []
}

output "route_table_public_ids" {
  value = aws_route_table.public[*].id
}

output "route_table_private_ids" {
  value = var.ngw_type != "none" ? aws_route_table.private[*].id : []
}

output "route_table_jumphost_id" {
  value = (
    var.jumphost_subnet != "" &&
    var.jumphost_allow_egress &&
    var.ngw_type != "none" &&
    length(aws_route_table.jumphost) > 0
  ) ? aws_route_table.jumphost[0].id : null
}

output "jumphost_security_group_id" {
  value = var.jumphost_subnet != "" ? aws_security_group.jumphost[0].id : null
}

output "jumphost_instance_id" {
  value = length(aws_instance.jumphost) > 0 ? aws_instance.jumphost[0].id : null
}

output "ec2_instance_connect_endpoint_id" {
  value = var.jumphost_subnet != "" ? aws_ec2_instance_connect_endpoint.this[0].id : null
}
