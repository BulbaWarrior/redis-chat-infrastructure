
resource "aws_vpc" "main" {
  cidr_block           = var.network_addr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "project network"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "mygateway"
  }
}

resource "aws_default_route_table" "main_route_table" {
  default_route_table_id = aws_vpc.main.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_subnet" "local_network" {
  vpc_id     = aws_vpc.main.id
yes  cidr_block = var.network_addr
}


