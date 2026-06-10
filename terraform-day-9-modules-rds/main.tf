resource "aws_db_instance" "myrds" {
  identifier             = "my-rds-instance"
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = var.rds_instance_class
  db_name                = var.rds_db_name
  username               = var.rds_username
  password               = var.rds_password
  #db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  skip_final_snapshot    = true
  tags = {
    Name = var.rds_tag
  }
}