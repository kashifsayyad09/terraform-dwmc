variable "subnet_ids" {
  description = "Private subnet IDs"
  type        = list(string)
}

variable "lambda_sg_id" {
  description = "Lambda Security Group ID"
  type        = string
}

variable "secret_arn" {
  description = "RDS Secret ARN"
  type        = string
}
