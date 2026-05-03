resource "aws_instance" "this" {
  ami                     = var.ami_id
  instance_type           = var.instance_type
  subnet_id               = var.subnet_id
  disable_api_termination = var.deletion_protection

  vpc_security_group_ids = var.vpc_security_group_ids
  key_name               = var.key_name
  user_data              = var.startup_script

  # For "static" mode the EIP below provides the public address; the instance
  # itself must NOT also request an ephemeral public IP.
  associate_public_ip_address = var.public_ip_mode == "ephemeral"

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  root_block_device {
    volume_size           = var.disk_size_gb
    volume_type           = "gp3"
    delete_on_termination = true
    encrypted             = true
  }

  tags = merge(
    { Name = var.instance_name },
    var.tags
  )
}

# Allocate and associate an Elastic IP only when public_ip_mode = "static".
resource "aws_eip" "this" {
  count  = var.public_ip_mode == "static" ? 1 : 0
  domain = "vpc"

  tags = merge(
    { Name = var.instance_name },
    var.tags
  )
}

resource "aws_eip_association" "this" {
  count         = var.public_ip_mode == "static" ? 1 : 0
  instance_id   = aws_instance.this.id
  allocation_id = aws_eip.this[0].id
}
