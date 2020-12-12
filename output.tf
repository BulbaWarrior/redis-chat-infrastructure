output "web_host_public_ips" {
  for_each = aws_instance.webapp_host
  value = each.public_ip
}

output "db_public_ip" {
  value = aws_instance.database_host.public_ip
}
