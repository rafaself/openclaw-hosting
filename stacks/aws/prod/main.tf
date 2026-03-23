locals {
  startup_script = templatefile(
    "${path.module}/../../../modules/startup_common/templates/startup_common.sh.tftpl",
    {
      swap_size_gb      = var.swap_size_gb
      tailscale_enabled = var.tailscale_enabled
    }
  )
}

module "vm" {
  source = "../../../modules/aws_vm"

  instance_name                = var.instance_name
  instance_type                = var.instance_type
  ami_id                       = var.ami_id
  subnet_id                    = var.subnet_id
  vpc_security_group_ids       = var.vpc_security_group_ids
  key_name                     = var.key_name
  associate_public_ip_address  = var.associate_public_ip_address
  disk_size_gb                 = var.disk_size_gb
  startup_script               = local.startup_script
  tags                         = var.tags
}
