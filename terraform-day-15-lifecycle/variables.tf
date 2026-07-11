variable "aws_region" {
  default = "us-east-1"
}

variable "db_username" {
  default = "admin"
}

variable "db_password" {
  sensitive = true
}

variable "allowed_cidr" {
  default = "0.0.0.0/0"
}