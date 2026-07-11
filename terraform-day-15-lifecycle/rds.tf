resource "aws_db_subnet_group" "mysql" {
  name = "mysql-subnet-group"

  subnet_ids = [
    aws_subnet.private1.id,
    aws_subnet.private2.id
  ]

  tags = {
    Name = "mysql-subnet-group"
  }
}

resource "aws_db_instance" "mysql" {

  identifier = "mysql-demo"

  engine         = "mysql"
  engine_version = "8.0"

  instance_class = "db.t3.micro"

  allocated_storage     = 20
  max_allocated_storage = 20
  storage_type          = "gp3"

  db_name  = "mydatabase"
  username = var.db_username
  password = var.db_password

  publicly_accessible = false

  multi_az = false

  db_subnet_group_name = aws_db_subnet_group.mysql.name

  vpc_security_group_ids = [
    aws_security_group.rds.id
  ]

  skip_final_snapshot = false

  final_snapshot_identifier = "mysql-demo-final"

  deletion_protection = true

  storage_encrypted = true

  backup_retention_period = 7

  auto_minor_version_upgrade = true

  apply_immediately = true

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name = "FreeTier-MySQL"
    Environment = "Dev"
  }
}