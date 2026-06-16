output "secret_arn" {
  value = aws_db_instance.mysql.master_user_secret[0].secret_arn
}

output "rds_endpoint" {
  value = aws_db_instance.mysql.address
}