data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "dedicated" {
  count = var.create_dedicated_network ? 1 : 0

  cidr_block           = var.dedicated_vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    { Name = "${var.instance_name}-vpc" },
    var.tags
  )
}

resource "aws_internet_gateway" "dedicated" {
  count = var.create_dedicated_network ? 1 : 0

  vpc_id = aws_vpc.dedicated[0].id

  tags = merge(
    { Name = "${var.instance_name}-igw" },
    var.tags
  )
}

resource "aws_subnet" "dedicated" {
  count = var.create_dedicated_network ? 1 : 0

  vpc_id                  = aws_vpc.dedicated[0].id
  cidr_block              = var.dedicated_subnet_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = var.public_ip_mode == "ephemeral"

  tags = merge(
    { Name = "${var.instance_name}-subnet" },
    var.tags
  )
}

resource "aws_route_table" "dedicated" {
  count = var.create_dedicated_network ? 1 : 0

  vpc_id = aws_vpc.dedicated[0].id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dedicated[0].id
  }

  tags = merge(
    { Name = "${var.instance_name}-public" },
    var.tags
  )
}

resource "aws_route_table_association" "dedicated" {
  count = var.create_dedicated_network ? 1 : 0

  subnet_id      = aws_subnet.dedicated[0].id
  route_table_id = aws_route_table.dedicated[0].id
}
