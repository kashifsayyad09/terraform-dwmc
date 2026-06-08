variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
}
variable "lambda_function_name" {
  description = "The name of the Lambda function"
  type        = string
}
variable "lambda_handler" {
  description = "The handler for the Lambda function"
  type        = string
}
variable "lambda_runtime" {
  description = "The runtime for the Lambda function"
  type        = string
}
variable "lambda_role_name" {
  description = "The name of the IAM role for Lambda execution"
  type        = string
}
variable "lambda_zip_file" {
  description = "The path to the zip file containing the Lambda function code"
  type        = string
}
variable "lambda_timeout" {
  description = "The timeout for the Lambda function in seconds"
  type        = number
  default     = 300
}