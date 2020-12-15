resource "aws_instance" "webapp_host" {
  ami                         = var.amis[var.region]
  instance_type               = "t2.micro"
  key_name                    = var.keys[var.region]
  subnet_id                   = aws_subnet.local_network.id
  count                       = 2
  associate_public_ip_address = true # for debug purposes
  vpc_security_group_ids      = [aws_security_group.local_sg.id]
  private_ip                  = cidrhost(local.web_subnet_addr, count.index + 1)
  user_data                   = templatefile("web.sh", { database_addr = local.database_addr, node_id = count.index + 1 })
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
  vpc_security_group_ids      = [aws_security_group.local_sg.id]
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
  vpc_security_group_ids      = [aws_security_group.local_sg.id]
  private_ip                  = local.loadbalancer_addr
  user_data                   = templatefile("loadbalancer.sh", { web_host_private_ips : aws_instance.webapp_host[*].private_ip })
  tags = {
    Name = "load balancer"
  }
}

resource "aws_instance" "backup_host" {
  ami                         = var.amis[var.region]
  instance_type               = "t2.micro"
  key_name                    = var.keys[var.region]
  subnet_id                   = aws_subnet.local_network.id
  associate_public_ip_address = true # for debug purposes
  vpc_security_group_ids      = [aws_security_group.local_sg.id]
  private_ip                  = local.backup_addr
  user_data                   = templatefile("backup.sh", { bacula_database_pass = var.bacula_database_pass })
  tags = {
    Name = "backup server"
  }
  depends_on = [aws_instance.webapp_host]

  provisioner "file" {
    source      = "config/backups/postfix/main.cf"
    destination = "/etc/postfix/main.cf"
  }
  provisioner "file" {
    source      = "config/backups/postfix/master.cf"
    destination = "/etc/postfix/master.cf"
  }
  provisioner "file" {
    content     = templatefile("config/backups/bacula/bacula-dir.conf", { backup_addr: local.backup_addr })
    destination = "/etc/bacula/bacula-dir.conf"
  }
  provisioner "file" {
    content     = templatefile("config/backups/bacula/bacula-sd.conf", { backup_addr: local.backup_addr })
    destination = "/etc/bacula/bacula-sd.conf"
  }
}

resource "aws_instance" "cicd_host" {
  ami                         = var.amis[var.region]
  instance_type               = "t2.micro"
  key_name                    = var.keys[var.region]
  subnet_id                   = aws_subnet.local_network.id
  associate_public_ip_address = true # for debug purposes
  vpc_security_group_ids      = [aws_security_group.local_sg.id]
  private_ip                  = local.cicd_addr
  user_data                   = templatefile("cicd.sh", {})
  tags = {
    Name = "cicd server"
  }
  depends_on = [aws_instance.webapp_host]
}
