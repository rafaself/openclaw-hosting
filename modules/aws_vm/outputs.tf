output "instance_name" {
  description = "Instance name."
  value       = var.instance_name
}

output "instance_id" {
  description = "Instance ID."
  value       = aws_instance.this.id
}

output "private_ip" {
  description = "Primary private IP."
  value       = aws_instance.this.private_ip
}

output "public_ip" {
  description = "Primary public IP, if present."
  value       = aws_instance.this.public_ip
}

output "admin_entrypoint" {
  description = "Recommended admin entrypoint."
  value       = "Use your preferred EC2 administrative path for ${var.instance_name}."
}
