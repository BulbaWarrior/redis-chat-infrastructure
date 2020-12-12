output "web_host_public_ips" {
  value = [aws_instance.webapp_host[0].public_ip, aws_instance.webapp_host[1].public_ip]
}

output "db_public_ip" {
  value = aws_instance.database_host.public_ip
}
