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



