resource "aws_db_instance" "mysql2" {

  identifier = "mysql-demo-2"

  engine         = "mysql"
  engine_version = "8.0"

  instance_class = "db.t3.micro"

  allocated_storage     = 20
  max_allocated_storage = 20
  storage_type          = "gp3"

  db_name  = "mydatabase2"
  username = var.db_username
  password = var.db_password

  publicly_accessible = false
  multi_az            = false

  db_subnet_group_name = aws_db_subnet_group.mysql.name

  vpc_security_group_ids = [
    aws_security_group.rds.id
  ]

  skip_final_snapshot     = false
  final_snapshot_identifier = "mysql-demo-2-final"

  deletion_protection = false
  storage_encrypted   = true

  backup_retention_period = 1

  apply_immediately = true

  lifecycle {
    prevent_destroy = false
  }

  tags = {
    Name = "mysql-demo-2"
    Environment = "Dev"
  }
}