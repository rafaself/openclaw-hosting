variable "region" {
  type        = string
  description = "AWS region."
  default     = "us-east-1"
}

variable "instance_name" {
  type        = string
  description = "EC2 instance name."
  default     = "agent-runtime-gw"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type."
  default     = "t3.small"
}

variable "ami_id" {
  type        = string
  description = "AMI ID to use for the instance."
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID for the instance."
}

variable "vpc_security_group_ids" {
  type        = list(string)
  description = "Security groups attached to the instance."
  default     = []
}

variable "key_name" {
  type        = string
  description = "Optional EC2 key pair name."
  default     = null
  nullable    = true
}

variable "associate_public_ip_address" {
  type        = bool
  description = "Whether to associate a public IPv4 address."
  default     = true
}

variable "disk_size_gb" {
  type        = number
  description = "Root volume size."
  default     = 20
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

variable "tags" {
  type        = map(string)
  description = "Tags applied to the stack."
  default = {
    Name      = "agent-runtime-gw"
    component = "agent-runtime"
    managedby = "opentofu"
  }
}
