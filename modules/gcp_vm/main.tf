resource "google_compute_instance" "this" {
  name                = var.instance_name
  machine_type        = var.machine_type
  zone                = var.zone
  deletion_protection = var.deletion_protection
  can_ip_forward      = false

  labels = var.labels
  tags   = var.tags

  boot_disk {
    initialize_params {
      image = var.boot_image
      size  = var.disk_size_gb
      type  = "pd-standard"
    }
  }

  network_interface {
    network    = var.network
    subnetwork = var.subnetwork

    dynamic "access_config" {
      for_each = var.enable_public_ip ? [1] : []
      content {}
    }
  }

  metadata = {
    enable-oslogin       = "TRUE"
    block-project-ssh-keys = "TRUE"
    serial-port-enable   = "FALSE"
  }

  metadata_startup_script = var.startup_script

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    provisioning_model  = "STANDARD"
  }

  shielded_instance_config {
    enable_secure_boot          = var.enable_secure_boot
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  }
}

resource "google_compute_firewall" "ssh_admin" {
  count = var.create_ssh_firewall && var.enable_public_ip ? 1 : 0

  name    = "${var.instance_name}-ssh-admin"
  network = var.network

  direction     = "INGRESS"
  source_ranges = var.ssh_source_cidrs
  target_tags   = length(var.tags) > 0 ? var.tags : null

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}
