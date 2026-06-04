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

variable "subnet_cidr_b" {
  description = "CIDR block for subnet B"
  default     = ""
}

variable "az_1a" {
  description = "Availability Zone for subnet A"
  default     = ""
}

variable "az_1b" {
  description = "Availability Zone for subnet B"
  default     = ""
}

variable "subnet_name1" {
  description = "Name tag for subnet A"
  default     = ""
}

variable "subnet_name2" {
  description = "Name tag for subnet B"
  default     = ""
}

