resource "aws_instance" "webapp_host" {
  ami           = var.amis[var.region]
  instance_type = "t2.micro"
  key_name      = var.keys[var.region]
  subnet_id     = aws_subnet.local_network.id
  count         = 2
  associate_public_ip_address = true # for debug purposes
  security_groups = [aws_security_group.network_sg.id]
}
