variable "instance_name" {
  type        = string
  description = "Instance name."

  validation {
    condition     = trimspace(var.instance_name) != ""
    error_message = "instance_name must not be empty. Provide a stable VM name such as 'agent-runtime-gw'."
  }
}

variable "zone" {
  type        = string
  description = "Compute Engine zone."

  validation {
    condition     = trimspace(var.zone) != ""
    error_message = "zone must not be empty. Set a GCP zone such as 'us-central1-a'."
  }
}

variable "machine_type" {
  type        = string
  description = "Compute Engine machine type."

  validation {
    condition     = trimspace(var.machine_type) != ""
    error_message = "machine_type must not be empty. Set a Compute Engine machine type such as 'e2-small'."
  }
}

variable "disk_size_gb" {
  type        = number
  description = "Boot disk size in GB."

  validation {
    condition     = var.disk_size_gb >= 10
    error_message = "disk_size_gb must be at least 10 GB to keep the host baseline usable."
  }
}

variable "boot_image" {
  type        = string
  description = "Boot image reference."

  validation {
    condition     = trimspace(var.boot_image) != ""
    error_message = "boot_image must not be empty. Use an image reference such as 'debian-cloud/debian-12'."
  }
}

variable "network" {
  type        = string
  description = "VPC network name."

  validation {
    condition     = trimspace(var.network) != ""
    error_message = "network must not be empty. Set the target VPC network name."
  }
}

variable "subnetwork" {
  type        = string
  description = "Optional subnetwork."
  default     = null
  nullable    = true

  validation {
    condition     = var.subnetwork == null || trimspace(var.subnetwork) != ""
    error_message = "subnetwork must be null or a non-empty subnetwork name or self-link."
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

variable "region" {
  type        = string
  description = "GCP region. Required when public_ip_mode is 'static' (used for the static IP reservation); ignored otherwise."
  default     = null

  validation {
    condition     = var.region == null || trimspace(var.region) != ""
    error_message = "region must be null or a non-empty GCP region such as 'us-central1'."
  }
}

variable "create_ssh_firewall" {
  type        = bool
  description = "Create a firewall rule for SSH."
  default     = true
}

variable "ssh_source_cidrs" {
  type        = list(string)
  description = "Source CIDRs allowed to SSH. Leave empty to keep SSH closed by default."
  default     = []

  validation {
    condition     = alltrue([for cidr in var.ssh_source_cidrs : can(cidrhost(cidr, 0))])
    error_message = "ssh_source_cidrs must contain valid CIDR blocks such as '203.0.113.10/32'. Leave it empty to keep SSH closed."
  }
}

variable "labels" {
  type        = map(string)
  description = "Instance labels."
  default     = {}
}

variable "tags" {
  type        = list(string)
  description = "Network tags."
  default     = []

  validation {
    condition     = alltrue([for tag in var.tags : trimspace(tag) != ""])
    error_message = "tags must not contain empty values. Remove blank tags or provide non-empty tag names."
  }
}

variable "startup_script" {
  type        = string
  description = "Startup script content."
  default     = ""
}

variable "deletion_protection" {
  type        = bool
  description = "Prevent accidental VM deletion through the API until explicitly disabled."
  default     = false
}

variable "enable_secure_boot" {
  type        = bool
  description = "Enable Shielded VM secure boot."
  default     = true
}
