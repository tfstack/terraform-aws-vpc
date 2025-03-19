variable "region" {
  description = "(Deprecated) AWS region for the provider. Defaults to ap-southeast-2 if not specified."
  type        = string
  default     = "ap-southeast-2"

  validation {
    condition     = can(regex("^([a-z]{2}-[a-z]+-\\d{1})$", var.region))
    error_message = "Invalid AWS region format. Example: 'us-east-1', 'ap-southeast-2'."
  }
}

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string

  validation {
    condition     = length(var.vpc_name) > 0
    error_message = "VPC name cannot be empty."
  }
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string

  validation {
    condition     = can(cidrsubnet(var.vpc_cidr, 0, 0))
    error_message = "Invalid CIDR block format for the VPC. Example: '10.0.0.0/16'."
  }
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)

  validation {
    condition     = length(var.availability_zones) > 0
    error_message = "At least one availability zone must be specified."
  }
}

variable "public_subnets" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for cidr in var.public_subnets : can(cidrsubnet(cidr, 0, 0))])
    error_message = "Each public subnet must be a valid CIDR block."
  }
}

variable "private_subnets" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for cidr in var.private_subnets : can(cidrsubnet(cidr, 0, 0))])
    error_message = "Each private subnet must be a valid CIDR block."
  }
}

variable "isolated_subnets" {
  description = "List of CIDR blocks for isolated subnets"
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for cidr in var.isolated_subnets : can(cidrsubnet(cidr, 0, 0))])
    error_message = "Each isolated subnet must be a valid CIDR block."
  }
}

variable "database_subnets" {
  description = "List of CIDR blocks for database subnets"
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for cidr in var.database_subnets : can(cidrsubnet(cidr, 0, 0))])
    error_message = "Each database subnet must be a valid CIDR block."
  }
}

variable "jumphost_subnet" {
  description = "CIDR block for the jump host subnet. If empty, the subnet will not be created."
  type        = string
  default     = ""

  validation {
    condition     = var.jumphost_subnet == "" || can(cidrsubnet(var.jumphost_subnet, 0, 0))
    error_message = "Invalid CIDR block for the jump host subnet."
  }
}

variable "tags" {
  description = "A map of tags to use on all resources"
  type        = map(string)
  default     = {}
}

variable "enable_eks_tags" {
  description = "Enable EKS role/internal-elb tags on private subnets"
  type        = bool
  default     = false
}

variable "create_igw" {
  description = "Whether to create an Internet Gateway (IGW) for public subnets"
  type        = bool
  default     = true
}

variable "ngw_type" {
  description = "Specify 'one_per_az' for high availability, 'single' for cost-saving, or 'none' to disable NAT Gateway"
  type        = string
  default     = "none"

  validation {
    condition     = contains(["one_per_az", "single", "none"], var.ngw_type)
    error_message = "Allowed values: 'one_per_az', 'single', 'none'."
  }

  validation {
    condition     = !(var.ngw_type != "none" && !var.create_igw)
    error_message = "NAT Gateway requires an Internet Gateway (IGW). Set 'create_igw' to true when using NAT Gateway."
  }
}

variable "eic_ingress_cidrs" {
  description = "List of CIDR blocks for allowed inbound SSH traffic to the EIC"
  type        = list(string)
  default     = ["0.0.0.0/0"]

  validation {
    condition     = alltrue([for cidr in var.eic_ingress_cidrs : can(cidrsubnet(cidr, 0, 0))])
    error_message = "Each ingress CIDR block must be valid."
  }
}

variable "jumphost_ingress_cidrs" {
  description = "(Deprecated) Use `eic_ingress_cidrs` instead. List of CIDR blocks for allowed inbound SSH traffic to the jumphost"
  type        = list(string)
  default     = ["0.0.0.0/0"]

  validation {
    condition     = alltrue([for cidr in var.jumphost_ingress_cidrs : can(cidrsubnet(cidr, 0, 0))])
    error_message = "Each ingress CIDR block must be valid."
  }
}


variable "jumphost_instance_type" {
  description = "The EC2 instance type for the jumphost"
  type        = string
  default     = "t3.micro"

  validation {
    condition     = can(regex("^[a-z0-9]+\\.[a-z0-9]+$", var.jumphost_instance_type))
    error_message = "Invalid EC2 instance type format. Example: 't3.micro', 'm5.large'."
  }
}

variable "jumphost_allow_egress" {
  description = "Whether to allow outbound internet access from the jumphost"
  type        = bool
  default     = false
}

variable "jumphost_user_data" {
  description = "Raw user data content for the EC2 instance. Takes precedence over file-based user data."
  type        = string
  default     = ""
}

variable "jumphost_user_data_file" {
  description = "Path to a user data file. If provided, its content will be used."
  type        = string
  default     = ""
}

variable "jumphost_user_data_template" {
  description = "Path to a user data template file. If provided, it will be rendered using `jumphost_user_data_template_vars`."
  type        = string
  default     = ""
}

variable "jumphost_user_data_template_vars" {
  description = "Variables for rendering the `jumphost_user_data_template` file."
  type        = map(any)
  default     = {}
}

variable "jumphost_iam_role_arns" {
  description = "List of IAM role ARNs to be included in policies."
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for r in var.jumphost_iam_role_arns : can(regex("^arn:aws:iam::(\\d{12}|aws):role/.*$", r))])
    error_message = "Each value in jumphost_iam_role_arns must be a valid IAM role ARN with a 12-digit account ID or 'aws'."
  }
}

variable "jumphost_inline_policy_arns" {
  description = "List of IAM inline policy ARNs to attach to the jumphost role."
  type        = list(string)
  default     = []
}

variable "jumphost_instance_create" {
  description = "Boolean flag to determine whether to create the jumphost instance."
  type        = bool
  default     = true
}

variable "jumphost_log_retention_days" {
  description = "The number of days to retain logs for the jumphost in CloudWatch"
  type        = number
  default     = 30
}

variable "jumphost_log_prevent_destroy" {
  description = "Whether to prevent the destruction of the CloudWatch log group"
  type        = bool
  default     = true
}

variable "eic_subnet" {
  description = "Set to 'jumphost', 'private', or 'none' to determine which subnet gets the EC2 Instance Connect Endpoint"
  type        = string
  default     = "none"

  validation {
    condition     = contains(["none", "jumphost", "private"], var.eic_subnet)
    error_message = "Allowed values for eic_subnet are 'jumphost', 'private', or 'none'."
  }

  validation {
    condition     = !(var.eic_subnet == "jumphost" && length(aws_subnet.jumphost) == 0)
    error_message = "Cannot set eic_subnet to 'jumphost' because the jumphost subnet does not exist."
  }

  validation {
    condition     = !(var.eic_subnet == "private" && length(aws_subnet.private) == 0)
    error_message = "Cannot set eic_subnet to 'private' because the private subnet does not exist."
  }
}

variable "eic_private_subnet" {
  description = "Specify which private subnet to use for EC2 Instance Connect Endpoint. Must be one of private_subnets or empty to use the first subnet."
  type        = string
  default     = ""

  validation {
    condition     = var.eic_private_subnet == "" || can(cidrhost(var.eic_private_subnet, 0))
    error_message = "Invalid CIDR format. Ensure eic_private_subnet is a valid CIDR block (e.g., '10.0.4.0/24')."
  }

  validation {
    condition     = var.eic_private_subnet == "" || contains(var.private_subnets, var.eic_private_subnet)
    error_message = "Invalid eic_private_subnet. Must be one of private_subnets or empty."
  }
}
