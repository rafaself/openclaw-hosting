output "instance_name" {
  description = "Instance name."
  value       = google_compute_instance.this.name
}

output "instance_id" {
  description = "Instance ID."
  value       = google_compute_instance.this.instance_id
}

output "private_ip" {
  description = "Primary private IP."
  value       = google_compute_instance.this.network_interface[0].network_ip
}

output "public_ip" {
  description = "Primary public IP, if present."
  value       = try(google_compute_instance.this.network_interface[0].access_config[0].nat_ip, null)
}

output "admin_entrypoint" {
  description = "Recommended admin entrypoint."
  value       = "gcloud compute ssh ${google_compute_instance.this.name} --zone ${google_compute_instance.this.zone}"
}
