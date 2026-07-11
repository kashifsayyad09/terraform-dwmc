output "endpoint" {
  value = aws_db_instance.mysql.endpoint
}

output "port" {
  value = aws_db_instance.mysql.port
}

output "database_name" {
  value = aws_db_instance.mysql.db_name
}

output "mysql2_endpoint" {
  value = aws_db_instance.mysql2.endpoint
}