variable "instance_name" {
  type        = string
  description = "Instance name."

  validation {
    condition     = trimspace(var.instance_name) != ""
    error_message = "instance_name must not be empty. Provide a stable EC2 instance name such as 'agent-runtime-gw'."
  }
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type."

  validation {
    condition     = trimspace(var.instance_type) != ""
    error_message = "instance_type must not be empty. Set an EC2 instance type such as 't3.small'."
  }
}

variable "ami_id" {
  type        = string
  description = "AMI ID."

  validation {
    condition     = trimspace(var.ami_id) != ""
    error_message = "ami_id must not be empty. Set the AMI ID for the instance image."
  }
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID."

  validation {
    condition     = trimspace(var.subnet_id) != ""
    error_message = "subnet_id must not be empty. Set the target subnet ID for the instance."
  }
}

variable "vpc_security_group_ids" {
  type        = list(string)
  description = "Security group IDs."
  default     = []

  validation {
    condition     = alltrue([for id in var.vpc_security_group_ids : trimspace(id) != ""])
    error_message = "vpc_security_group_ids must not contain empty values. Remove blank IDs or provide valid security group IDs."
  }
}

variable "key_name" {
  type        = string
  description = "Optional SSH key pair name."
  default     = null
  nullable    = true

  validation {
    condition     = var.key_name == null || trimspace(var.key_name) != ""
    error_message = "key_name must be null or a non-empty EC2 key pair name."
  }
}

variable "public_ip_mode" {
  type        = string
  description = "Public IP mode: 'none' (no public IP), 'ephemeral' (auto-assigned), or 'static' (persistent Elastic IP)."
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

variable "startup_script" {
  type        = string
  description = "User data startup script."
  default     = ""
}

variable "deletion_protection" {
  type        = bool
  description = "Prevent accidental instance termination through the API until explicitly disabled."
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "Instance tags."
  default     = {}

  validation {
    condition     = alltrue([for key, value in var.tags : trimspace(key) != "" && trimspace(value) != ""])
    error_message = "tags must use non-empty keys and values. Remove blank entries before applying."
  }
}
