variable "region" {
  type        = string
  description = "AWS region."
  default     = "us-east-1"

  validation {
    condition     = trimspace(var.region) != ""
    error_message = "region must not be empty. Set an AWS region such as 'us-east-1'."
  }
}

variable "instance_name" {
  type        = string
  description = "EC2 instance name."
  default     = "agent-runtime-gw"

  validation {
    condition     = trimspace(var.instance_name) != ""
    error_message = "instance_name must not be empty. Provide a stable EC2 instance name such as 'agent-runtime-gw'."
  }
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type."
  default     = "t3.small"

  validation {
    condition     = trimspace(var.instance_type) != ""
    error_message = "instance_type must not be empty. Set an EC2 instance type such as 't3.small'."
  }
}

variable "ami_id" {
  type        = string
  description = "AMI ID to use for the instance."

  validation {
    condition     = trimspace(var.ami_id) != ""
    error_message = "ami_id must not be empty. Set the AMI ID for the instance image before planning or applying."
  }
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID for the instance."

  validation {
    condition     = trimspace(var.subnet_id) != ""
    error_message = "subnet_id must not be empty. Set the target subnet ID before planning or applying."
  }
}

variable "vpc_security_group_ids" {
  type        = list(string)
  description = "Security groups attached to the instance."
  default     = []

  validation {
    condition     = alltrue([for id in var.vpc_security_group_ids : trimspace(id) != ""])
    error_message = "vpc_security_group_ids must not contain empty values. Remove blank IDs or provide valid security group IDs."
  }
}

variable "key_name" {
  type        = string
  description = "Optional EC2 key pair name."
  default     = null
  nullable    = true

  validation {
    condition     = var.key_name == null || trimspace(var.key_name) != ""
    error_message = "key_name must be null or a non-empty EC2 key pair name."
  }
}

variable "public_ip_mode" {
  type        = string
  description = "Public IP mode: 'none', 'ephemeral', or 'static'."
  default     = "ephemeral"

  validation {
    condition     = contains(["none", "ephemeral", "static"], var.public_ip_mode)
    error_message = "public_ip_mode must be one of 'none', 'ephemeral', or 'static'. Use 'none' for private-only access."
  }
}

variable "disk_size_gb" {
  type        = number
  description = "Root volume size."
  default     = 20

  validation {
    condition     = var.disk_size_gb >= 10
    error_message = "disk_size_gb must be at least 10 GB to keep the host baseline usable."
  }
}

variable "deletion_protection" {
  type        = bool
  description = "Prevent accidental instance termination through the API until explicitly disabled."
  default     = false
}

variable "swap_size_gb" {
  type        = number
  description = "Swap file size for the startup script."
  default     = 2

  validation {
    condition     = var.swap_size_gb >= 0
    error_message = "swap_size_gb must be 0 or greater. Use 0 to disable swap file creation."
  }
}

variable "tailscale_enabled" {
  type        = bool
  description = "Whether to install Tailscale in the startup script."
  default     = true
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to the stack."
  default = {
    Name      = "agent-runtime-gw"
    component = "agent-runtime"
    managedby = "opentofu"
  }

  validation {
    condition     = alltrue([for key, value in var.tags : trimspace(key) != "" && trimspace(value) != ""])
    error_message = "tags must use non-empty keys and values. Remove blank entries before applying."
  }
}
