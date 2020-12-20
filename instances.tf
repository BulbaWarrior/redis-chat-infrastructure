resource "aws_instance" "webapp_host" {
  ami                         = var.amis[var.region]
  instance_type               = "t2.micro"
  key_name                    = var.keys[var.region]
  subnet_id                   = aws_subnet.local_network.id
  count                       = 2
  associate_public_ip_address = true # for debug purposes
  vpc_security_group_ids      = [aws_security_group.local_sg.id]
  private_ip                  = cidrhost(local.web_subnet_addr, count.index + 1)
  tags = {
    Name = "web server"
  }
  depends_on = [aws_instance.database_host]

  connection {
    type        = "ssh"
    user        = var.ssh_username
    private_key = var.ssh_key
    host        = self.public_ip
  }
  provisioner "file" {
    content     = templatefile("configs/backups/bacula/bacula-fd.conf", { addr : self.private_ip, name : "web-${count.index}-fd" })
    destination = "/tmp/bacula-fd.conf"
  }
  user_data = join("\n", [
    file("bacula-client.sh"),
    templatefile("web.sh", { database_addr = local.database_addr, node_id = count.index + 1 }),
  ])
}

resource "aws_instance" "database_host" {
  ami                         = var.amis[var.region]
  instance_type               = "t2.micro"
  key_name                    = var.keys[var.region]
  subnet_id                   = aws_subnet.local_network.id
  associate_public_ip_address = true # for debug purposes
  vpc_security_group_ids      = [aws_security_group.local_sg.id]
  private_ip                  = local.database_addr
  tags = {
    Name = "database server"
  }

  connection {
    type        = "ssh"
    user        = var.ssh_username
    private_key = var.ssh_key
    host        = self.public_ip
  }
  provisioner "file" {
    content     = templatefile("configs/backups/bacula/bacula-fd.conf", { addr : self.private_ip, name : "database-fd" })
    destination = "/tmp/bacula-fd.conf"
  }
  user_data = join("\n", [
    file("bacula-client.sh"),
    file("databases.sh"),
  ])
}

resource "aws_instance" "loadbalancer_host" {
  ami                         = var.amis[var.region]
  instance_type               = "t2.micro"
  key_name                    = var.keys[var.region]
  subnet_id                   = aws_subnet.local_network.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.local_sg.id]
  private_ip                  = local.loadbalancer_addr
  tags = {
    Name = "load balancer"
  }

  connection {
    type        = "ssh"
    user        = var.ssh_username
    private_key = var.ssh_key
    host        = self.public_ip
  }
  provisioner "file" {
    content     = templatefile("configs/backups/bacula/bacula-fd.conf", { addr : self.private_ip, name : "loadbalancer-fd" })
    destination = "/tmp/bacula-fd.conf"
  }
  user_data = join("\n", [
    file("bacula-client.sh"),
    templatefile("loadbalancer.sh", { web_host_private_ips : aws_instance.webapp_host[*].private_ip }),
  ])
}

resource "aws_instance" "backup_host" {
  ami                         = var.amis[var.region]
  instance_type               = "t2.micro"
  key_name                    = var.keys[var.region]
  subnet_id                   = aws_subnet.local_network.id
  associate_public_ip_address = true # for debug purposes
  vpc_security_group_ids      = [aws_security_group.local_sg.id]
  private_ip                  = local.backup_addr
  tags = {
    Name = "backup server"
  }
  depends_on = [aws_instance.webapp_host]

  connection {
    type        = "ssh"
    user        = var.ssh_username
    private_key = var.ssh_key
    host        = self.public_ip
  }
  provisioner "file" {
    source      = "configs/backups/postfix/main.cf"
    destination = "/tmp/main.cf"
  }
  provisioner "file" {
    source      = "configs/backups/postfix/master.cf"
    destination = "/tmp/master.cf"
  }
  provisioner "file" {
    content     = templatefile("configs/backups/bacula/bconsole.conf", { addr : self.private_ip })
    destination = "/tmp/bconsole.conf"
  }
  provisioner "file" {
    content = templatefile("configs/backups/bacula/bacula-dir.conf", {
      database_pass : var.bacula_database_pass,
      my_addr : self.private_ip,
      web_host_private_ips : aws_instance.webapp_host[*].private_ip,
      loadbalancer_private_ip : aws_instance.loadbalancer_host.private_ip,
      database_private_ip : aws_instance.database_host.private_ip,
    cicd_private_ip : aws_instance.cicd_host.private_ip })
    destination = "/tmp/bacula-dir.conf"
  }
  provisioner "file" {
    content     = templatefile("configs/backups/bacula/bacula-sd.conf", { addr : self.private_ip })
    destination = "/tmp/bacula-sd.conf"
  }
  user_data = templatefile("backup.sh", { bacula_database_pass = var.bacula_database_pass })
}

resource "aws_instance" "cicd_host" {
  ami                         = var.amis[var.region]
  instance_type               = "t2.micro"
  key_name                    = var.keys[var.region]
  subnet_id                   = aws_subnet.local_network.id
  associate_public_ip_address = true # for debug purposes
  vpc_security_group_ids      = [aws_security_group.local_sg.id]
  private_ip                  = local.cicd_addr
  tags = {
    Name = "cicd server"
  }
  depends_on = [aws_instance.webapp_host]

  connection {
    type        = "ssh"
    user        = var.ssh_username
    private_key = var.ssh_key
    host        = self.public_ip
  }
  provisioner "file" {
    content     = templatefile("configs/backups/bacula/bacula-fd.conf", { addr : self.private_ip, name : "cicd-fd" })
    destination = "/tmp/bacula-fd.conf"
  }
  user_data = join("\n", [
    file("bacula-client.sh"),
    file("cicd.sh"),
  ])
}
