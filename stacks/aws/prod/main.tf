locals {
  startup_script = var.enable_startup_bootstrap ? templatefile(
    "${path.module}/../../../modules/startup_common/templates/startup_common.sh.tftpl",
    {
      swap_size_gb = var.swap_size_gb
    }
  ) : ""
}

module "vm" {
  source = "../../../modules/aws_vm"

  instance_name          = var.instance_name
  instance_type          = var.instance_type
  ami_id                 = var.ami_id
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.vpc_security_group_ids
  key_name               = var.key_name
  public_ip_mode         = var.public_ip_mode
  disk_size_gb           = var.disk_size_gb
  deletion_protection    = var.deletion_protection
  startup_script         = local.startup_script
  tags                   = var.tags
}
