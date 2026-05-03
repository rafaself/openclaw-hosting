output "instance_name" {
  description = "Provisioned instance name."
  value       = module.vm.instance_name
}

output "instance_id" {
  description = "Provisioned instance ID."
  value       = module.vm.instance_id
}

output "private_ip" {
  description = "Primary private IP address."
  value       = module.vm.private_ip
}

output "public_ip" {
  description = "Public IP address, if enabled."
  value       = module.vm.public_ip
}

output "vpc_id" {
  description = "Dedicated VPC ID when created by the stack. Null when reusing existing networking."
  value       = try(aws_vpc.dedicated[0].id, null)
}

output "subnet_id" {
  description = "Subnet used by the instance."
  value       = local.subnet_id
}

output "service_account_email" {
  description = "Service account email equivalent for the instance. Not used on AWS."
  value       = module.vm.service_account_email
}

output "admin_entrypoint" {
  description = "Recommended admin entrypoint."
  value       = module.vm.admin_entrypoint
}
