variable "instance_name" {
  type        = string
  description = "Instance name."
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type."
}

variable "ami_id" {
  type        = string
  description = "AMI ID."
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID."
}

variable "vpc_security_group_ids" {
  type        = list(string)
  description = "Security group IDs."
  default     = []
}

variable "key_name" {
  type        = string
  description = "Optional SSH key pair name."
  default     = null
  nullable    = true
}

variable "associate_public_ip_address" {
  type        = bool
  description = "Whether to associate a public IP."
  default     = true
}

variable "disk_size_gb" {
  type        = number
  description = "Root volume size."
  default     = 20
}

variable "startup_script" {
  type        = string
  description = "User data startup script."
  default     = ""
}

variable "tags" {
  type        = map(string)
  description = "Instance tags."
  default     = {}
}
