
resource "aws_vpc" "main" {
  cidr_block           = var.network_addr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "project network"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "mygateway"
  }
}

resource "aws_subnet" "local_network" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.network_addr
}

resource "aws_security_group" "network_sg" {

  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
