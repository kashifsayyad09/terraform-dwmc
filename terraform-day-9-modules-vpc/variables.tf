variable "vpc_cidr" {
  description = "vpc cidr block"
  type = string
  default = ""
}

variable "subnet_cidr1" {
  description = "subnet1 cidr block"
  type = string
  default = ""
}

variable "subnet_cidr2" {
  description = "subnet2 cidr block"
  type = string
  default = ""
}

variable "az1" {
  description = "avaliability Zone-1a"
  type = string
  default = ""
}

variable "az2" {
  description = "avaliability Zone-1b"
  type = string
  default = ""
}

variable "vpc_name" {
  description = "vpc_name"
  type = string
  default = ""
}

variable "vpc_id" {
  type = string
}

variable "igw_name" {
  type = string
}