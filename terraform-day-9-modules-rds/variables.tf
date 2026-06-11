variable "rds_db_name" {
  description = "The name of the database to create"
  type        = string
  default     = "mydb"
  
}
variable "rds_username" {
  description = "The username for the database"
  type        = string
  default     = "admin"
}
variable "rds_password" {
  description = "The password for the database"
  type        = string
  default     = "password123"
}
variable "rds_instance_class" {
  description = "The instance class for the RDS instance"
  type        = string
  default     = "db.t3.micro"
}

variable "rds_tag" {
  description = "tags"
  type = string
  default = ""
} 
variable "rds_subnet_group" {
  description = "subnet group"
  type = string
  default = "subnet-group"
}
variable "subnet_ids" {
  description = "subnet ids"
  type = list(string)
  default = ["subnet7_id", "subnet8_id"]
}

variable "rds_security_group" {
  description = "security group"
  type = string
  default = ""
}
variable "sg_id" {
  description = "security group id"
  type = string
  default = "sg_id"
}

variable "rds_vpc_id" {
  description = "vpc id"
  type = string
  default = ""
}