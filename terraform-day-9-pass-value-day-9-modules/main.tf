module "ec2" {
  source = "../terraform-day-9-modules-ec2"
  ami_id        = "ami-0152204c1a187337c"
  instance_type = "t2.micro"
  counts        = 2
  name = "terraform-day-9-ec2"
}

module "rds" {
  source = "../terraform-day-9-modules-rds"
  rds_db_name = "mydb"
  rds_username = "admin"
  rds_password = "Root1234"
  rds_instance_class ="db.t3.micro"
  rds_tag = "Db-21"


}


