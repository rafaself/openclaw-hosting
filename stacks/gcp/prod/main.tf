locals {
  startup_script = var.enable_startup_bootstrap ? templatefile(
    "${path.module}/../../../modules/startup_common/templates/startup_common.sh.tftpl",
    {
      swap_size_gb = var.swap_size_gb
    }
  ) : ""

  network    = var.create_dedicated_network ? google_compute_network.dedicated[0].self_link : var.network
  subnetwork = var.create_dedicated_network ? google_compute_subnetwork.dedicated[0].self_link : var.subnetwork
}

module "vm" {
  source = "../../../modules/gcp_vm"

  instance_name       = var.instance_name
  zone                = var.zone
  machine_type        = var.machine_type
  disk_size_gb        = var.disk_size_gb
  boot_image          = var.boot_image
  network             = local.network
  subnetwork          = local.subnetwork
  public_ip_mode      = var.public_ip_mode
  region              = var.region
  create_ssh_firewall = var.create_ssh_firewall
  ssh_source_cidrs    = var.ssh_source_cidrs
  labels              = var.labels
  tags                = var.tags
  deletion_protection = var.deletion_protection
  startup_script      = local.startup_script
}
