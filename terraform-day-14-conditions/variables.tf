variable "dev" {
  type    = bool
  default = false
}

variable "aws_region" {
  description = "AWS region where infrastructure will be created"
  type        = string
  nullable    = false
  default     = "us-west-2"

  validation {
    condition = (
      var.aws_region == "us-west-2" ||
      var.aws_region == "ap-south-1"
    )

    error_message = "Variable 'aws_region' must be either 'us-west-2' or 'ap-south-1'."
  }
}


variable "environment" {
  type    = string
  default = "test"
}