# terraform-aws-vpc

Terraform module for provisioning a VPC with networking components

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.84.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.84.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_iam_policy_chunker"></a> [iam\_policy\_chunker](#module\_iam\_policy\_chunker) | tfstack/iam-policy-chunker/aws | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_ec2_instance_connect_endpoint.this](https://registry.terraform.io/providers/hashicorp/aws/5.84.0/docs/resources/ec2_instance_connect_endpoint) | resource |
| [aws_eip.this](https://registry.terraform.io/providers/hashicorp/aws/5.84.0/docs/resources/eip) | resource |
| [aws_iam_instance_profile.jumphost](https://registry.terraform.io/providers/hashicorp/aws/5.84.0/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.jumphost](https://registry.terraform.io/providers/hashicorp/aws/5.84.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.jumphost](https://registry.terraform.io/providers/hashicorp/aws/5.84.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_instance.jumphost](https://registry.terraform.io/providers/hashicorp/aws/5.84.0/docs/resources/instance) | resource |
| [aws_internet_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/5.84.0/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/5.84.0/docs/resources/nat_gateway) | resource |
| [aws_route_table.jumphost](https://registry.terraform.io/providers/hashicorp/aws/5.84.0/docs/resources/route_table) | resource |
| [aws_route_table.private](https://registry.terraform.io/providers/hashicorp/aws/5.84.0/docs/resources/route_table) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/5.84.0/docs/resources/route_table) | resource |
| [aws_route_table_association.jumphost](https://registry.terraform.io/providers/hashicorp/aws/5.84.0/docs/resources/route_table_association) | resource |
| [aws_route_table_association.private](https://registry.terraform.io/providers/hashicorp/aws/5.84.0/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/5.84.0/docs/resources/route_table_association) | resource |
| [aws_security_group.jumphost](https://registry.terraform.io/providers/hashicorp/aws/5.84.0/docs/resources/security_group) | resource |
| [aws_subnet.database](https://registry.terraform.io/providers/hashicorp/aws/5.84.0/docs/resources/subnet) | resource |
| [aws_subnet.isolated](https://registry.terraform.io/providers/hashicorp/aws/5.84.0/docs/resources/subnet) | resource |
| [aws_subnet.jumphost](https://registry.terraform.io/providers/hashicorp/aws/5.84.0/docs/resources/subnet) | resource |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/5.84.0/docs/resources/subnet) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/5.84.0/docs/resources/subnet) | resource |
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/5.84.0/docs/resources/vpc) | resource |
| [aws_ami.amzn2023](https://registry.terraform.io/providers/hashicorp/aws/5.84.0/docs/data-sources/ami) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/5.84.0/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/5.84.0/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | List of availability zones | `list(string)` | n/a | yes |
| <a name="input_create_igw"></a> [create\_igw](#input\_create\_igw) | Whether to create an Internet Gateway (IGW) for public subnets | `bool` | `true` | no |
| <a name="input_database_subnets"></a> [database\_subnets](#input\_database\_subnets) | List of CIDR blocks for database subnets | `list(string)` | `[]` | no |
| <a name="input_isolated_subnets"></a> [isolated\_subnets](#input\_isolated\_subnets) | List of CIDR blocks for isolated subnets | `list(string)` | `[]` | no |
| <a name="input_jumphost_allow_egress"></a> [jumphost\_allow\_egress](#input\_jumphost\_allow\_egress) | Whether to allow outbound internet access from the jumphost | `bool` | `false` | no |
| <a name="input_jumphost_iam_role_arns"></a> [jumphost\_iam\_role\_arns](#input\_jumphost\_iam\_role\_arns) | List of IAM role ARNs to be included in policies. | `list(string)` | `[]` | no |
| <a name="input_jumphost_ingress_cidrs"></a> [jumphost\_ingress\_cidrs](#input\_jumphost\_ingress\_cidrs) | List of CIDR blocks for allowed inbound SSH traffic to the jumphost | `list(string)` | <pre>[<br/>  "0.0.0.0/0"<br/>]</pre> | no |
| <a name="input_jumphost_inline_policy_arns"></a> [jumphost\_inline\_policy\_arns](#input\_jumphost\_inline\_policy\_arns) | List of IAM inline policy ARNs to attach to the jumphost role. | `list(string)` | `[]` | no |
| <a name="input_jumphost_instance_create"></a> [jumphost\_instance\_create](#input\_jumphost\_instance\_create) | Boolean flag to determine whether to create the jumphost instance. | `bool` | `true` | no |
| <a name="input_jumphost_instance_type"></a> [jumphost\_instance\_type](#input\_jumphost\_instance\_type) | The EC2 instance type for the jumphost | `string` | `"t3.micro"` | no |
| <a name="input_jumphost_subnet"></a> [jumphost\_subnet](#input\_jumphost\_subnet) | CIDR block for the jump host subnet. If empty, the subnet will not be created. | `string` | `""` | no |
| <a name="input_jumphost_user_data"></a> [jumphost\_user\_data](#input\_jumphost\_user\_data) | Raw user data content for the EC2 instance. Takes precedence over file-based user data. | `string` | `""` | no |
| <a name="input_jumphost_user_data_file"></a> [jumphost\_user\_data\_file](#input\_jumphost\_user\_data\_file) | Path to a user data file. If provided, its content will be used. | `string` | `""` | no |
| <a name="input_jumphost_user_data_template"></a> [jumphost\_user\_data\_template](#input\_jumphost\_user\_data\_template) | Path to a user data template file. If provided, it will be rendered using `jumphost_user_data_template_vars`. | `string` | `""` | no |
| <a name="input_jumphost_user_data_template_vars"></a> [jumphost\_user\_data\_template\_vars](#input\_jumphost\_user\_data\_template\_vars) | Variables for rendering the `jumphost_user_data_template` file. | `map(any)` | `{}` | no |
| <a name="input_ngw_type"></a> [ngw\_type](#input\_ngw\_type) | Specify 'one\_per\_az' for high availability, 'single' for cost-saving, or 'none' to disable NAT Gateway | `string` | `"none"` | no |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | List of CIDR blocks for private subnets | `list(string)` | `[]` | no |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | List of CIDR blocks for public subnets | `list(string)` | `[]` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region for the provider. Defaults to ap-southeast-2 if not specified. | `string` | `"ap-southeast-2"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to use on all resources | `map(string)` | `{}` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | CIDR block for the VPC | `string` | n/a | yes |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | The name of the VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_database_subnet_ids"></a> [database\_subnet\_ids](#output\_database\_subnet\_ids) | n/a |
| <a name="output_ec2_instance_connect_endpoint_id"></a> [ec2\_instance\_connect\_endpoint\_id](#output\_ec2\_instance\_connect\_endpoint\_id) | n/a |
| <a name="output_eip_allocations"></a> [eip\_allocations](#output\_eip\_allocations) | n/a |
| <a name="output_internet_gateway_id"></a> [internet\_gateway\_id](#output\_internet\_gateway\_id) | n/a |
| <a name="output_isolated_subnet_ids"></a> [isolated\_subnet\_ids](#output\_isolated\_subnet\_ids) | n/a |
| <a name="output_jumphost_instance_id"></a> [jumphost\_instance\_id](#output\_jumphost\_instance\_id) | n/a |
| <a name="output_jumphost_security_group_id"></a> [jumphost\_security\_group\_id](#output\_jumphost\_security\_group\_id) | n/a |
| <a name="output_jumphost_subnet_id"></a> [jumphost\_subnet\_id](#output\_jumphost\_subnet\_id) | n/a |
| <a name="output_nat_gateway_ids"></a> [nat\_gateway\_ids](#output\_nat\_gateway\_ids) | n/a |
| <a name="output_private_subnet_ids"></a> [private\_subnet\_ids](#output\_private\_subnet\_ids) | n/a |
| <a name="output_public_subnet_ids"></a> [public\_subnet\_ids](#output\_public\_subnet\_ids) | n/a |
| <a name="output_region"></a> [region](#output\_region) | n/a |
| <a name="output_route_table_jumphost_id"></a> [route\_table\_jumphost\_id](#output\_route\_table\_jumphost\_id) | n/a |
| <a name="output_route_table_private_ids"></a> [route\_table\_private\_ids](#output\_route\_table\_private\_ids) | n/a |
| <a name="output_route_table_public_ids"></a> [route\_table\_public\_ids](#output\_route\_table\_public\_ids) | n/a |
| <a name="output_vpc_cidr"></a> [vpc\_cidr](#output\_vpc\_cidr) | n/a |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | n/a |
