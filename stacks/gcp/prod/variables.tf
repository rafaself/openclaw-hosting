variable "project_id" {
  type        = string
  description = "GCP project ID."

  validation {
    condition     = trimspace(var.project_id) != ""
    error_message = "project_id must not be empty. Set the target GCP project ID before planning or applying."
  }
}

variable "region" {
  type        = string
  description = "GCP region."
  default     = "us-central1"

  validation {
    condition     = trimspace(var.region) != ""
    error_message = "region must not be empty. Set a GCP region such as 'us-central1'."
  }
}

variable "zone" {
  type        = string
  description = "GCP zone."
  default     = "us-central1-a"

  validation {
    condition     = trimspace(var.zone) != ""
    error_message = "zone must not be empty. Set a GCP zone such as 'us-central1-a'."
  }
}

variable "instance_name" {
  type        = string
  description = "VM name."
  default     = "agent-runtime-gw"

  validation {
    condition     = trimspace(var.instance_name) != ""
    error_message = "instance_name must not be empty. Provide a stable VM name such as 'agent-runtime-gw'."
  }
}

variable "machine_type" {
  type        = string
  description = "Compute Engine machine type."
  default     = "e2-small"

  validation {
    condition     = trimspace(var.machine_type) != ""
    error_message = "machine_type must not be empty. Set a Compute Engine machine type such as 'e2-small'."
  }
}

variable "disk_size_gb" {
  type        = number
  description = "Boot disk size in GB."
  default     = 20

  validation {
    condition     = var.disk_size_gb >= 10
    error_message = "disk_size_gb must be at least 10 GB to keep the host baseline usable."
  }
}

variable "boot_image" {
  type        = string
  description = "Boot image family/project reference."
  default     = "debian-cloud/debian-12"

  validation {
    condition     = trimspace(var.boot_image) != ""
    error_message = "boot_image must not be empty. Use an image reference such as 'debian-cloud/debian-12'."
  }
}

variable "network" {
  type        = string
  description = "VPC network name."
  default     = "default"

  validation {
    condition     = trimspace(var.network) != ""
    error_message = "network must not be empty. Set the target VPC network name."
  }
}

variable "subnetwork" {
  type        = string
  description = "Optional subnetwork self-link or name."
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

variable "create_ssh_firewall" {
  type        = bool
  description = "Whether to create a minimal SSH firewall rule."
  default     = true
}

variable "ssh_source_cidrs" {
  type        = list(string)
  description = "Allowed source CIDRs for SSH when a public IP is enabled. Leave empty to keep SSH closed by default."
  default     = []

  validation {
    condition     = alltrue([for cidr in var.ssh_source_cidrs : can(cidrhost(cidr, 0))])
    error_message = "ssh_source_cidrs must contain valid CIDR blocks such as '203.0.113.10/32'. Leave it empty to keep SSH closed."
  }
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

variable "labels" {
  type        = map(string)
  description = "Labels applied to the VM."
  default = {
    component = "agent-runtime"
    managedby = "opentofu"
  }

  validation {
    condition     = alltrue([for key, value in var.labels : trimspace(key) != "" && trimspace(value) != ""])
    error_message = "labels must use non-empty keys and values. Remove blank entries before applying."
  }
}

variable "tags" {
  type        = list(string)
  description = "Network tags applied to the VM."
  default     = ["agent-runtime", "ssh-admin"]

  validation {
    condition     = alltrue([for tag in var.tags : trimspace(tag) != ""])
    error_message = "tags must not contain empty values. Remove blank tags or provide non-empty tag names."
  }
}

variable "deletion_protection" {
  type        = bool
  description = "Prevent accidental VM deletion through the API until explicitly disabled."
  default     = false
}
