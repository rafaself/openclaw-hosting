variable "project_id" {
  type        = string
  description = "GCP project ID."
}

variable "region" {
  type        = string
  description = "GCP region."
  default     = "us-central1"
}

variable "zone" {
  type        = string
  description = "GCP zone."
  default     = "us-central1-a"
}

variable "instance_name" {
  type        = string
  description = "VM name."
  default     = "agent-runtime-gw"
}

variable "machine_type" {
  type        = string
  description = "Compute Engine machine type."
  default     = "e2-small"
}

variable "disk_size_gb" {
  type        = number
  description = "Boot disk size in GB."
  default     = 20
}

variable "boot_image" {
  type        = string
  description = "Boot image family/project reference."
  default     = "debian-cloud/debian-12"
}

variable "network" {
  type        = string
  description = "VPC network name."
  default     = "default"
}

variable "subnetwork" {
  type        = string
  description = "Optional subnetwork self-link or name."
  default     = null
  nullable    = true
}

variable "public_ip_mode" {
  type        = string
  description = "Public IP mode: 'none', 'ephemeral', or 'static'."
  default     = "ephemeral"
  validation {
    condition     = contains(["none", "ephemeral", "static"], var.public_ip_mode)
    error_message = "The public_ip_mode value must be 'none', 'ephemeral', or 'static'."
  }
}

variable "create_ssh_firewall" {
  type        = bool
  description = "Whether to create a minimal SSH firewall rule."
  default     = true
}

variable "ssh_source_cidrs" {
  type        = list(string)
  description = "Allowed source CIDRs for SSH when a public IP is enabled."
  default     = ["0.0.0.0/0"]
}

variable "swap_size_gb" {
  type        = number
  description = "Swap file size for the startup script."
  default     = 2
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
}

variable "tags" {
  type        = list(string)
  description = "Network tags applied to the VM."
  default     = ["agent-runtime", "ssh-admin"]
}
