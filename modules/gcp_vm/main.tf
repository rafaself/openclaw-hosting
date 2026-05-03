locals {
  service_account_name = trim(regexreplace(lower(var.instance_name), "[^a-z0-9-]", "-"), "-")
  service_account_id   = "vm-${substr(length(local.service_account_name) > 0 ? local.service_account_name : "runtime", 0, 18)}-${substr(md5(var.instance_name), 0, 8)}"
}

resource "google_compute_address" "static" {
  count  = var.public_ip_mode == "static" ? 1 : 0
  name   = "${var.instance_name}-ip"
  region = var.region

  lifecycle {
    precondition {
      condition     = var.region != null
      error_message = "var.region must be set when public_ip_mode is 'static'."
    }
  }
}

resource "google_service_account" "vm" {
  account_id   = local.service_account_id
  display_name = "${var.instance_name} VM service account"
  description  = "Dedicated service account for ${var.instance_name}."
}

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
      for_each = var.public_ip_mode != "none" ? [1] : []
      content {
        nat_ip = var.public_ip_mode == "static" ? google_compute_address.static[0].address : null
      }
    }
  }

  metadata = {
    enable-oslogin         = "TRUE"
    block-project-ssh-keys = "TRUE"
    serial-port-enable     = "FALSE"
  }

  service_account {
    email = google_service_account.vm.email
    scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring.write",
    ]
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
  count = var.create_ssh_firewall && var.public_ip_mode != "none" && length(var.ssh_source_cidrs) > 0 ? 1 : 0

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
