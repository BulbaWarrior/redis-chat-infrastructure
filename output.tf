output "web_host_public_ips" {
  value = aws_instance.webapp_host[*].public_ip
}

output "db_public_ip" {
  value = aws_instance.database_host.public_ip
}


output "loadbalancer_public_ip" {
  value = aws_instance.loadbalancer_host.public_ip
}
