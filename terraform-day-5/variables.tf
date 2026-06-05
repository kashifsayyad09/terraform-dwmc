variable "aws_region" {
  description = "AWS region to deploy resources"
  default     = ""
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = ""
}

variable "subnet_cidr_a" {
  description = "CIDR block for subnet A"
  default     = ""
}

variable "subnet_cidr_c" {
  description = "CIDR block for subnet C"
  default     = ""
}

variable "az_1a" {
  description = "Availability Zone for subnet A"
  default     = ""
}

variable "az_1c" {
  description = "Availability Zone for subnet B"
  default     = ""
}

variable "subnet_name1" {
  description = "Name tag for subnet A"
  default     = ""
}

variable "subnet_name3" {
  description = "Name tag for subnet C"
  default     = ""
}

variable "rds_db_name" {
  description = "Name of the RDS database"
  default     = ""
}

variable "rds_username" {
  description = "Username for the RDS database"
  default     = ""
}

variable "rds_password" {
  description = "Password for the RDS database"
  default     = ""
}

variable "rds_instance_class" {
  description = "Instance class for the RDS database"
  default     = ""
}