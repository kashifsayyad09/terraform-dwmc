module "vpc" {
  vpc_id = "vpc.main.id"
  source = "../terraform-day-9-modules-vpc"
  vpc_cidr = "10.0.0.0/16"
  subnet_cidr1 = "10.0.0.0/24"
  subnet_cidr2 = "10.0.1.0/24"
  subnet_cidr3 = "10.0.2.0/24"
  subnet_cidr4 = "10.0.3.0/24"
  subnet_cidr5 = "10.0.4.0/24"
  subnet_cidr6 = "10.0.5.0/24"
  subnet_cidr7 = "10.0.6.0/24"
  subnet_cidr8 = "10.0.7.0/24"
  igw_name = "my-igw"
  az1 = "us-east-1a"
  az2 = "us-east-1b"
  vpc_name = "Main-VPC"
}

module "securitygroup" {
  source = "../terraform-day-9-modules-security-group"
  sg-name = "web-sg"
  vpc_id = module.vpc.vpc_id
  sg-rds = "rds-sg"
   
}

module "ec2" {
  source = "../terraform-day-9-modules-ec2"
  ami_id        = "ami-0152204c1a187337c"
  instance_type = "t3.micro"
  counts        = 2
  name = "terraform-day-9-ec2"
  subnet_id = module.vpc.subnet1_id
  security_group_id = module.securitygroup.ec2_sg_id
}

module "rds" {
  source = "../terraform-day-9-modules-rds"
  rds_db_name = "mydb"
  rds_username = "admin"
  rds_password = "Root1234"
  rds_instance_class ="db.t3.micro"
  rds_tag = "Db-21"
  rds_subnet_group = "mydb-subnet-group"
  rds_security_group = module.securitygroup.rds_sg_id
  
}