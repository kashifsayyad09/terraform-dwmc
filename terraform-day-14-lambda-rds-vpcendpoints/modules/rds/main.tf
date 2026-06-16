resource "aws_db_subnet_group" "rds_subnet_group" {

  name       = "rds-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "rds-subnet-group"
  }
}

resource "aws_db_instance" "mysql" {

  identifier = "mydbinstance"

  allocated_storage = 20

  engine         = "mysql"
  engine_version = "8.0"

  instance_class = "db.t3.micro"

  db_name = "mydb"

  manage_master_user_password = true

  username = "admin"

  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name

  vpc_security_group_ids = [
    var.rds_sg_id
  ]

  publicly_accessible = false

  skip_final_snapshot = true

  deletion_protection = false

  tags = {
    Name = "my-rds-instance"
  }
}