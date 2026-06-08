variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = ""
}

variable "lambda_function_name" {
  description = "Name of the Lambda function"
  type        = string
  default     = ""
}

variable "lambda_handler" {
  description = "Handler for the Lambda function"
  type        = string
  default     = ""
}

variable "lambda_runtime" {
  description = "Runtime for the Lambda function"
  type        = string
  default     = ""
}

variable "lambda_timeout" {
  description = "Timeout for the Lambda function in seconds"
  type        = number
  default     = 300
}

