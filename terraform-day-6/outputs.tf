output "web_server_public_ip" {
  value = aws_instance.web_server.public_ip
}

output "app_server_private_ip" {
  value = aws_instance.app_server.private_ip
}

output "rds_instance_endpoint" {
  value = aws_db_instance.my_rds.endpoint
}