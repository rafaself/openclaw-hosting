variable "instance_name" {
  type        = string
  description = "Instance name."
}

variable "zone" {
  type        = string
  description = "Compute Engine zone."
}

variable "machine_type" {
  type        = string
  description = "Compute Engine machine type."
}

variable "disk_size_gb" {
  type        = number
  description = "Boot disk size in GB."
}

variable "boot_image" {
  type        = string
  description = "Boot image reference."
}

variable "network" {
  type        = string
  description = "VPC network name."
}

variable "subnetwork" {
  type        = string
  description = "Optional subnetwork."
  default     = null
  nullable    = true
}

variable "enable_public_ip" {
  type        = bool
  description = "Attach a public IP address."
  default     = true
}

variable "create_ssh_firewall" {
  type        = bool
  description = "Create a firewall rule for SSH."
  default     = true
}

variable "ssh_source_cidrs" {
  type        = list(string)
  description = "Source CIDRs allowed to SSH."
  default     = ["0.0.0.0/0"]
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
}

variable "startup_script" {
  type        = string
  description = "Startup script content."
  default     = ""
}

variable "deletion_protection" {
  type        = bool
  description = "Deletion protection."
  default     = false
}

variable "enable_secure_boot" {
  type        = bool
  description = "Enable Shielded VM secure boot."
  default     = true
}
