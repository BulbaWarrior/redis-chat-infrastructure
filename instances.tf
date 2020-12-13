resource "aws_instance" "webapp_host" {
  ami                         = var.amis[var.region]
  instance_type               = "t2.micro"
  key_name                    = var.keys[var.region]
  subnet_id                   = aws_subnet.local_network.id
  count                       = 2
  associate_public_ip_address = true # for debug purposes
  security_groups             = [aws_security_group.local_sg.id]
  private_ip                  = cidrhost(local.web_subnet_addr, count.index + 1)
  user_data                   = templatefile("web.sh", { database_addr = local.database_addr })
  tags = {
    Name = "web server"
  }
  depends_on = [aws_instance.database_host]
}

resource "aws_instance" "database_host" {
  ami                         = var.amis[var.region]
  instance_type               = "t2.micro"
  key_name                    = var.keys[var.region]
  subnet_id                   = aws_subnet.local_network.id
  associate_public_ip_address = true # for debug purposes
  security_groups             = [aws_security_group.local_sg.id]
  private_ip                  = local.database_addr
  user_data                   = file("databases.sh")
  tags = {
    Name = "database server"
  }
}

resource "aws_instance" "loadbalancer_host" {
  ami                         = var.amis[var.region]
  instance_type               = "t2.micro"
  key_name                    = var.keys[var.region]
  subnet_id                   = aws_subnet.local_network.id
  associate_public_ip_address = true
  security_groups             = [aws_security_group.local_sg.id]
  private_ip                  = local.loadbalancer_addr
  user_data                   = templatefile("loadbalancer.sh", {web_host_private_ips: aws_instance.webapp_host[*].private_ip})
  tags = {
    Name = "load balancer"
  }
}
