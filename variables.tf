variable "region" {
  description = "AWS region for the provider. Defaults to ap-southeast-2 if not specified."
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

variable "jumphost_ingress_cidrs" {
  description = "List of CIDR blocks for allowed inbound SSH traffic to the jumphost"
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
