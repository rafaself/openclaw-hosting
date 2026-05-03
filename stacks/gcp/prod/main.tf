locals {
  startup_script = var.enable_startup_bootstrap ? templatefile(
    "${path.module}/../../../modules/startup_common/templates/startup_common.sh.tftpl",
    {
      swap_size_gb = var.swap_size_gb
    }
  ) : ""
}

module "vm" {
  source = "../../../modules/gcp_vm"

  instance_name       = var.instance_name
  zone                = var.zone
  machine_type        = var.machine_type
  disk_size_gb        = var.disk_size_gb
  boot_image          = var.boot_image
  network             = var.network
  subnetwork          = var.subnetwork
  public_ip_mode      = var.public_ip_mode
  region              = var.region
  create_ssh_firewall = var.create_ssh_firewall
  ssh_source_cidrs    = var.ssh_source_cidrs
  labels              = var.labels
  tags                = var.tags
  deletion_protection = var.deletion_protection
  startup_script      = local.startup_script
}
