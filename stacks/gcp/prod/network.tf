resource "google_compute_network" "dedicated" {
  count = var.create_dedicated_network ? 1 : 0

  name                    = "${var.instance_name}-vpc"
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

resource "google_compute_subnetwork" "dedicated" {
  count = var.create_dedicated_network ? 1 : 0

  name                     = "${var.instance_name}-${var.region}-subnet"
  ip_cidr_range            = var.dedicated_subnet_cidr
  region                   = var.region
  network                  = google_compute_network.dedicated[0].id
  private_ip_google_access = true
}
