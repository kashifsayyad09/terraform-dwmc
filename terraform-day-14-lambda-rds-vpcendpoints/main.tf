module "vpc" {
  source = "./modules/vpc"

  vpc_cidr     = "10.0.0.0/16"
  vpc_name     = "demo-vpc"

  subnet_cidr1 = "10.0.1.0/24"
  subnet_cidr2 = "10.0.2.0/24"

  subnet_name1 = "private-subnet-1"
  subnet_name2 = "private-subnet-2"

  az1 = "us-east-1a"
  az2 = "us-east-1b"
}

module "security_groups" {
  source = "./modules/security-groups"

  vpc_id = module.vpc.vpc_id
}

module "rds" {
  source = "./modules/rds"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.subnet_ids
  rds_sg_id = module.security_groups.rds_sg_id
}

module "lambda" {
  source = "./modules/lambda"

  subnet_ids   = module.vpc.subnet_ids
  lambda_sg_id = module.security_groups.lambda_sg_id

  secret_arn = module.rds.secret_arn
}

