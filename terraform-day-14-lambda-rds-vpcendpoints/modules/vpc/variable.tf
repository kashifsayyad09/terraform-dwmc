variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "vpc_name" {
  description = "Name of VPC"
  type        = string
}

variable "subnet_cidr1" {
  description = "CIDR block for subnet 1"
  type        = string
}

variable "subnet_cidr2" {
  description = "CIDR block for subnet 2"
  type        = string
}

variable "subnet_name1" {
  description = "Name of subnet 1"
  type        = string
}

variable "subnet_name2" {
  description = "Name of subnet 2"
  type        = string
}

variable "az1" {
  description = "Availability Zone 1"
  type        = string
}

variable "az2" {
  description = "Availability Zone 2"
  type        = string
}