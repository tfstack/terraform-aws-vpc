# terraform-aws-vpc

[![Terraform Lint & Validate](https://github.com/tfstack/terraform-aws-vpc/actions/workflows/terraform-lint-validate.yml/badge.svg)](https://github.com/tfstack/terraform-aws-vpc/actions/workflows/terraform-lint-validate.yml)
[![Markdown Lint](https://github.com/tfstack/terraform-aws-vpc/actions/workflows/markdown-lint.yml/badge.svg)](https://github.com/tfstack/terraform-aws-vpc/actions/workflows/markdown-lint.yml)
[![Commit Message Conformance](https://github.com/tfstack/terraform-aws-vpc/actions/workflows/commitmsg-conform.yml/badge.svg)](https://github.com/tfstack/terraform-aws-vpc/actions/workflows/commitmsg-conform.yml)

Terraform module for provisioning a VPC with networking components

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_iam_policy_chunker"></a> [iam\_policy\_chunker](#module\_iam\_policy\_chunker) | tfstack/iam-policy-chunker/aws | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.jumphost_with_prevent_destroy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.jumphost_without_prevent_destroy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_ec2_instance_connect_endpoint.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_instance_connect_endpoint) | resource |
| [aws_eip.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_iam_instance_profile.jumphost](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_policy.jumphost_logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.jumphost](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.jumphost](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.jumphost_logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_instance.jumphost](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_internet_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route_table.database](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.isolated](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.jumphost_allow_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.jumphost_no_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.database](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.isolated](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.jumphost](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_security_group.eic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.database](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.isolated](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.jumphost](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_vpc_endpoint.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_ami.amzn2023](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_security_group.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group) | data source |
| [template_file.user_data](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | List of availability zones | `list(string)` | n/a | yes |
| <a name="input_create_igw"></a> [create\_igw](#input\_create\_igw) | Whether to create an Internet Gateway (IGW) for public subnets | `bool` | `true` | no |
| <a name="input_database_subnets"></a> [database\_subnets](#input\_database\_subnets) | List of CIDR blocks for database subnets | `list(string)` | `[]` | no |
| <a name="input_eic_ingress_cidrs"></a> [eic\_ingress\_cidrs](#input\_eic\_ingress\_cidrs) | List of CIDR blocks for allowed inbound SSH traffic to the EIC | `list(string)` | <pre>[<br/>  "0.0.0.0/0"<br/>]</pre> | no |
| <a name="input_eic_private_subnet"></a> [eic\_private\_subnet](#input\_eic\_private\_subnet) | Specify which private subnet to use for EC2 Instance Connect Endpoint. Must be one of private\_subnets or empty to use the first subnet. | `string` | `""` | no |
| <a name="input_eic_subnet"></a> [eic\_subnet](#input\_eic\_subnet) | Set to 'jumphost', 'private', or 'none' to determine which subnet gets the EC2 Instance Connect Endpoint | `string` | `"none"` | no |
| <a name="input_eks_cluster_name"></a> [eks\_cluster\_name](#input\_eks\_cluster\_name) | EKS cluster name to use for kubernetes.io/cluster/<name> tag | `string` | `null` | no |
| <a name="input_enable_eks_tags"></a> [enable\_eks\_tags](#input\_enable\_eks\_tags) | Enable EKS role/internal-elb tags on private subnets | `bool` | `false` | no |
| <a name="input_enable_s3_vpc_endpoint"></a> [enable\_s3\_vpc\_endpoint](#input\_enable\_s3\_vpc\_endpoint) | Whether to create the S3 VPC endpoint | `bool` | `false` | no |
| <a name="input_isolated_subnets"></a> [isolated\_subnets](#input\_isolated\_subnets) | List of CIDR blocks for isolated subnets | `list(string)` | `[]` | no |
| <a name="input_jumphost_allow_egress"></a> [jumphost\_allow\_egress](#input\_jumphost\_allow\_egress) | Whether to allow outbound internet access from the jumphost | `bool` | `false` | no |
| <a name="input_jumphost_iam_role_arns"></a> [jumphost\_iam\_role\_arns](#input\_jumphost\_iam\_role\_arns) | List of IAM role ARNs to be included in policies. | `list(string)` | `[]` | no |
| <a name="input_jumphost_ingress_cidrs"></a> [jumphost\_ingress\_cidrs](#input\_jumphost\_ingress\_cidrs) | (Deprecated) Use `eic_ingress_cidrs` instead. List of CIDR blocks for allowed inbound SSH traffic to the jumphost | `list(string)` | <pre>[<br/>  "0.0.0.0/0"<br/>]</pre> | no |
| <a name="input_jumphost_inline_policy_arns"></a> [jumphost\_inline\_policy\_arns](#input\_jumphost\_inline\_policy\_arns) | List of IAM inline policy ARNs to attach to the jumphost role. | `list(string)` | `[]` | no |
| <a name="input_jumphost_instance_create"></a> [jumphost\_instance\_create](#input\_jumphost\_instance\_create) | Boolean flag to determine whether to create the jumphost instance. | `bool` | `true` | no |
| <a name="input_jumphost_instance_type"></a> [jumphost\_instance\_type](#input\_jumphost\_instance\_type) | The EC2 instance type for the jumphost | `string` | `"t3.micro"` | no |
| <a name="input_jumphost_log_prevent_destroy"></a> [jumphost\_log\_prevent\_destroy](#input\_jumphost\_log\_prevent\_destroy) | Whether to prevent the destruction of the CloudWatch log group | `bool` | `true` | no |
| <a name="input_jumphost_log_retention_days"></a> [jumphost\_log\_retention\_days](#input\_jumphost\_log\_retention\_days) | The number of days to retain logs for the jumphost in CloudWatch | `number` | `30` | no |
| <a name="input_jumphost_subnet"></a> [jumphost\_subnet](#input\_jumphost\_subnet) | CIDR block for the jump host subnet. If empty, the subnet will not be created. | `string` | `""` | no |
| <a name="input_jumphost_user_data"></a> [jumphost\_user\_data](#input\_jumphost\_user\_data) | Raw shell script content for the EC2 instance. Takes precedence over file-based user data. | `string` | `""` | no |
| <a name="input_jumphost_user_data_file"></a> [jumphost\_user\_data\_file](#input\_jumphost\_user\_data\_file) | Path to a user data file. If provided, its content will be used. | `string` | `""` | no |
| <a name="input_jumphost_user_data_template"></a> [jumphost\_user\_data\_template](#input\_jumphost\_user\_data\_template) | Path to a user data template file. If provided, it will be rendered using `jumphost_user_data_template_vars`. | `string` | `""` | no |
| <a name="input_jumphost_user_data_template_vars"></a> [jumphost\_user\_data\_template\_vars](#input\_jumphost\_user\_data\_template\_vars) | Variables for rendering the `jumphost_user_data_template` file. | `map(any)` | `{}` | no |
| <a name="input_ngw_type"></a> [ngw\_type](#input\_ngw\_type) | Specify 'one\_per\_az' for high availability, 'single' for cost-saving, or 'none' to disable NAT Gateway | `string` | `"none"` | no |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | List of CIDR blocks for private subnets | `list(string)` | `[]` | no |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | List of CIDR blocks for public subnets | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to use on all resources | `map(string)` | `{}` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | CIDR block for the VPC | `string` | n/a | yes |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | The name of the VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_database_subnet_cidrs"></a> [database\_subnet\_cidrs](#output\_database\_subnet\_cidrs) | CIDR blocks of database subnets |
| <a name="output_database_subnet_ids"></a> [database\_subnet\_ids](#output\_database\_subnet\_ids) | IDs of all database subnets |
| <a name="output_eic_endpoint_id"></a> [eic\_endpoint\_id](#output\_eic\_endpoint\_id) | ID of the EC2 Instance Connect Endpoint (if created) |
| <a name="output_eic_security_group_id"></a> [eic\_security\_group\_id](#output\_eic\_security\_group\_id) | ID of the security group used by EC2 Instance Connect (EIC), if defined |
| <a name="output_eip_allocations"></a> [eip\_allocations](#output\_eip\_allocations) | List of Elastic IP allocation IDs (if created) |
| <a name="output_internet_gateway_id"></a> [internet\_gateway\_id](#output\_internet\_gateway\_id) | ID of the Internet Gateway (if created) |
| <a name="output_isolated_subnet_cidrs"></a> [isolated\_subnet\_cidrs](#output\_isolated\_subnet\_cidrs) | CIDR blocks of isolated subnets |
| <a name="output_isolated_subnet_ids"></a> [isolated\_subnet\_ids](#output\_isolated\_subnet\_ids) | IDs of all isolated subnets |
| <a name="output_jumphost_instance_id"></a> [jumphost\_instance\_id](#output\_jumphost\_instance\_id) | ID of the jumphost EC2 instance (if created) |
| <a name="output_jumphost_subnet_cidr"></a> [jumphost\_subnet\_cidr](#output\_jumphost\_subnet\_cidr) | CIDR block of the jumphost subnet (if defined) |
| <a name="output_jumphost_subnet_id"></a> [jumphost\_subnet\_id](#output\_jumphost\_subnet\_id) | ID of the jumphost subnet (if defined) |
| <a name="output_nat_gateway_ids"></a> [nat\_gateway\_ids](#output\_nat\_gateway\_ids) | List of NAT Gateway IDs (if created) |
| <a name="output_private_subnet_cidrs"></a> [private\_subnet\_cidrs](#output\_private\_subnet\_cidrs) | CIDR blocks of private subnets |
| <a name="output_private_subnet_ids"></a> [private\_subnet\_ids](#output\_private\_subnet\_ids) | IDs of all private subnets |
| <a name="output_public_subnet_cidrs"></a> [public\_subnet\_cidrs](#output\_public\_subnet\_cidrs) | CIDR blocks of public subnets |
| <a name="output_public_subnet_ids"></a> [public\_subnet\_ids](#output\_public\_subnet\_ids) | IDs of all public subnets |
| <a name="output_region"></a> [region](#output\_region) | The current AWS region |
| <a name="output_route_table_private_ids"></a> [route\_table\_private\_ids](#output\_route\_table\_private\_ids) | IDs of private route tables |
| <a name="output_route_table_public_ids"></a> [route\_table\_public\_ids](#output\_route\_table\_public\_ids) | IDs of public route tables |
| <a name="output_s3_vpc_endpoint_id"></a> [s3\_vpc\_endpoint\_id](#output\_s3\_vpc\_endpoint\_id) | The ID of the S3 VPC Endpoint |
| <a name="output_vpc_cidr"></a> [vpc\_cidr](#output\_vpc\_cidr) | The CIDR block of the created VPC |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the created VPC |

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.0.0 |
| <a name="provider_template"></a> [template](#provider\_template) | 2.2.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_iam_policy_chunker"></a> [iam\_policy\_chunker](#module\_iam\_policy\_chunker) | tfstack/iam-policy-chunker/aws | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.jumphost_with_prevent_destroy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.jumphost_without_prevent_destroy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_ec2_instance_connect_endpoint.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_instance_connect_endpoint) | resource |
| [aws_eip.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_iam_instance_profile.jumphost](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_policy.jumphost_logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.jumphost](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.jumphost](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.jumphost_logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_instance.jumphost](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_internet_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route_table.database](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.isolated](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.jumphost_allow_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.jumphost_no_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.database](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.isolated](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.jumphost](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_security_group.eic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.database](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.isolated](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.jumphost](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_vpc_endpoint.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_ami.amzn2023](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_security_group.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group) | data source |
| [template_file.user_data](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | List of availability zones | `list(string)` | n/a | yes |
| <a name="input_create_igw"></a> [create\_igw](#input\_create\_igw) | Whether to create an Internet Gateway (IGW) for public subnets | `bool` | `true` | no |
| <a name="input_database_subnets"></a> [database\_subnets](#input\_database\_subnets) | List of CIDR blocks for database subnets | `list(string)` | `[]` | no |
| <a name="input_eic_ingress_cidrs"></a> [eic\_ingress\_cidrs](#input\_eic\_ingress\_cidrs) | List of CIDR blocks for allowed inbound SSH traffic to the EIC | `list(string)` | <pre>[<br/>  "0.0.0.0/0"<br/>]</pre> | no |
| <a name="input_eic_private_subnet"></a> [eic\_private\_subnet](#input\_eic\_private\_subnet) | Specify which private subnet to use for EC2 Instance Connect Endpoint. Must be one of private\_subnets or empty to use the first subnet. | `string` | `""` | no |
| <a name="input_eic_subnet"></a> [eic\_subnet](#input\_eic\_subnet) | Set to 'jumphost', 'private', or 'none' to determine which subnet gets the EC2 Instance Connect Endpoint | `string` | `"none"` | no |
| <a name="input_eks_cluster_name"></a> [eks\_cluster\_name](#input\_eks\_cluster\_name) | EKS cluster name to use for kubernetes.io/cluster/<name> tag | `string` | `null` | no |
| <a name="input_enable_eks_tags"></a> [enable\_eks\_tags](#input\_enable\_eks\_tags) | Enable EKS role/internal-elb tags on private subnets | `bool` | `false` | no |
| <a name="input_enable_s3_vpc_endpoint"></a> [enable\_s3\_vpc\_endpoint](#input\_enable\_s3\_vpc\_endpoint) | Whether to create the S3 VPC endpoint | `bool` | `false` | no |
| <a name="input_isolated_subnets"></a> [isolated\_subnets](#input\_isolated\_subnets) | List of CIDR blocks for isolated subnets | `list(string)` | `[]` | no |
| <a name="input_jumphost_allow_egress"></a> [jumphost\_allow\_egress](#input\_jumphost\_allow\_egress) | Whether to allow outbound internet access from the jumphost | `bool` | `false` | no |
| <a name="input_jumphost_iam_role_arns"></a> [jumphost\_iam\_role\_arns](#input\_jumphost\_iam\_role\_arns) | List of IAM role ARNs to be included in policies. | `list(string)` | `[]` | no |
| <a name="input_jumphost_ingress_cidrs"></a> [jumphost\_ingress\_cidrs](#input\_jumphost\_ingress\_cidrs) | (Deprecated) Use `eic_ingress_cidrs` instead. List of CIDR blocks for allowed inbound SSH traffic to the jumphost | `list(string)` | <pre>[<br/>  "0.0.0.0/0"<br/>]</pre> | no |
| <a name="input_jumphost_inline_policy_arns"></a> [jumphost\_inline\_policy\_arns](#input\_jumphost\_inline\_policy\_arns) | List of IAM inline policy ARNs to attach to the jumphost role. | `list(string)` | `[]` | no |
| <a name="input_jumphost_instance_create"></a> [jumphost\_instance\_create](#input\_jumphost\_instance\_create) | Boolean flag to determine whether to create the jumphost instance. | `bool` | `true` | no |
| <a name="input_jumphost_instance_type"></a> [jumphost\_instance\_type](#input\_jumphost\_instance\_type) | The EC2 instance type for the jumphost | `string` | `"t3.micro"` | no |
| <a name="input_jumphost_log_prevent_destroy"></a> [jumphost\_log\_prevent\_destroy](#input\_jumphost\_log\_prevent\_destroy) | Whether to prevent the destruction of the CloudWatch log group | `bool` | `true` | no |
| <a name="input_jumphost_log_retention_days"></a> [jumphost\_log\_retention\_days](#input\_jumphost\_log\_retention\_days) | The number of days to retain logs for the jumphost in CloudWatch | `number` | `30` | no |
| <a name="input_jumphost_subnet"></a> [jumphost\_subnet](#input\_jumphost\_subnet) | CIDR block for the jump host subnet. If empty, the subnet will not be created. | `string` | `""` | no |
| <a name="input_jumphost_user_data"></a> [jumphost\_user\_data](#input\_jumphost\_user\_data) | Raw shell script content for the EC2 instance. Takes precedence over file-based user data. | `string` | `""` | no |
| <a name="input_jumphost_user_data_file"></a> [jumphost\_user\_data\_file](#input\_jumphost\_user\_data\_file) | Path to a user data file. If provided, its content will be used. | `string` | `""` | no |
| <a name="input_jumphost_user_data_template"></a> [jumphost\_user\_data\_template](#input\_jumphost\_user\_data\_template) | Path to a user data template file. If provided, it will be rendered using `jumphost_user_data_template_vars`. | `string` | `""` | no |
| <a name="input_jumphost_user_data_template_vars"></a> [jumphost\_user\_data\_template\_vars](#input\_jumphost\_user\_data\_template\_vars) | Variables for rendering the `jumphost_user_data_template` file. | `map(any)` | `{}` | no |
| <a name="input_ngw_type"></a> [ngw\_type](#input\_ngw\_type) | Specify 'one\_per\_az' for high availability, 'single' for cost-saving, or 'none' to disable NAT Gateway | `string` | `"none"` | no |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | List of CIDR blocks for private subnets | `list(string)` | `[]` | no |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | List of CIDR blocks for public subnets | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to use on all resources | `map(string)` | `{}` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | CIDR block for the VPC | `string` | n/a | yes |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | The name of the VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_database_subnet_cidrs"></a> [database\_subnet\_cidrs](#output\_database\_subnet\_cidrs) | CIDR blocks of database subnets |
| <a name="output_database_subnet_ids"></a> [database\_subnet\_ids](#output\_database\_subnet\_ids) | IDs of all database subnets |
| <a name="output_eic_endpoint_id"></a> [eic\_endpoint\_id](#output\_eic\_endpoint\_id) | ID of the EC2 Instance Connect Endpoint (if created) |
| <a name="output_eic_security_group_id"></a> [eic\_security\_group\_id](#output\_eic\_security\_group\_id) | ID of the security group used by EC2 Instance Connect (EIC), if defined |
| <a name="output_eip_allocations"></a> [eip\_allocations](#output\_eip\_allocations) | List of Elastic IP allocation IDs (if created) |
| <a name="output_internet_gateway_id"></a> [internet\_gateway\_id](#output\_internet\_gateway\_id) | ID of the Internet Gateway (if created) |
| <a name="output_isolated_subnet_cidrs"></a> [isolated\_subnet\_cidrs](#output\_isolated\_subnet\_cidrs) | CIDR blocks of isolated subnets |
| <a name="output_isolated_subnet_ids"></a> [isolated\_subnet\_ids](#output\_isolated\_subnet\_ids) | IDs of all isolated subnets |
| <a name="output_jumphost_instance_id"></a> [jumphost\_instance\_id](#output\_jumphost\_instance\_id) | ID of the jumphost EC2 instance (if created) |
| <a name="output_jumphost_subnet_cidr"></a> [jumphost\_subnet\_cidr](#output\_jumphost\_subnet\_cidr) | CIDR block of the jumphost subnet (if defined) |
| <a name="output_jumphost_subnet_id"></a> [jumphost\_subnet\_id](#output\_jumphost\_subnet\_id) | ID of the jumphost subnet (if defined) |
| <a name="output_nat_gateway_ids"></a> [nat\_gateway\_ids](#output\_nat\_gateway\_ids) | List of NAT Gateway IDs (if created) |
| <a name="output_private_subnet_cidrs"></a> [private\_subnet\_cidrs](#output\_private\_subnet\_cidrs) | CIDR blocks of private subnets |
| <a name="output_private_subnet_ids"></a> [private\_subnet\_ids](#output\_private\_subnet\_ids) | IDs of all private subnets |
| <a name="output_public_subnet_cidrs"></a> [public\_subnet\_cidrs](#output\_public\_subnet\_cidrs) | CIDR blocks of public subnets |
| <a name="output_public_subnet_ids"></a> [public\_subnet\_ids](#output\_public\_subnet\_ids) | IDs of all public subnets |
| <a name="output_region"></a> [region](#output\_region) | The current AWS region |
| <a name="output_route_table_private_ids"></a> [route\_table\_private\_ids](#output\_route\_table\_private\_ids) | IDs of private route tables |
| <a name="output_route_table_public_ids"></a> [route\_table\_public\_ids](#output\_route\_table\_public\_ids) | IDs of public route tables |
| <a name="output_s3_vpc_endpoint_id"></a> [s3\_vpc\_endpoint\_id](#output\_s3\_vpc\_endpoint\_id) | The ID of the S3 VPC Endpoint |
| <a name="output_vpc_cidr"></a> [vpc\_cidr](#output\_vpc\_cidr) | The CIDR block of the created VPC |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the created VPC |
<!-- END_TF_DOCS -->