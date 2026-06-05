#main.tf variables.tf
variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = ""

}

variable "subnet1_cidr_block" {
  description = "CIDR block for subnet 1"
  type        = string
  default     = ""
}

variable "subnet2_cidr_block" {
  description = "CIDR block for subnet 2"
  type        = string
  default     = ""
}

variable "subnet3_cidr_block" {
  description = "CIDR block for subnet 3"
  type        = string
  default     = ""
}

variable "subnet4_cidr_block" {
  description = "CIDR block for subnet 4"
  type        = string
  default     = ""
}

variable "az1" {
  description = "Availability Zone 1"
  type        = string
  default     = ""
}

variable "az2" {
  description = "Availability Zone 2"
  type        = string
  default     = ""
}

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = ""
}

variable "key_pair_name" {
  description = "Name of the AWS key pair to use for EC2 instances"
  type        = string
  default     = ""
}

variable "rds_instance_class" {
  description = "Instance class for the RDS instance"
  type        = string
  default     = ""
}

variable "rds_username" {
  description = "Username for the RDS instance"
  type        = string
  default     = ""
}

variable "rds_password" {
  description = "Password for the RDS instance"
  type        = string
  default     = ""
}

variable "rds_db_name" {
  description = "Database name for the RDS instance"
  type        = string
  default     = ""
}

variable "rds_allocated_storage" {
  description = "Allocated storage (in GB) for the RDS instance"
  type        = number
  default     = 20
}

variable "ami_id" {
  description = "AMI ID for the EC2 instances"
  type        = string
  default     = ""
}

variable "instance_type" {
  description = "Instance type for the EC2 instances"
  type        = string
  default     = ""
}

variable "instance_count" {
  description = "Number of EC2 instances to create"
  type        = number
  default     = 1
}


