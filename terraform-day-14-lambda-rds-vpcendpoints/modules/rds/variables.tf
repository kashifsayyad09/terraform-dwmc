variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  description = "Private subnet IDs"
  type        = list(string)
}

variable "rds_sg_id" {
  description = "RDS Security Group ID"
  type        = string
}