variable "ami_id" {
  description = "The AMI ID to use for the instance"
  type        = string
}

variable "instance_type" {
  description = "The type of instance to use"
  type        = string
}

variable "counts" {
  description = "The number of instances to create"
  type        = number
}

variable "name" {
  description = "The name to use for the instance"
  type        = string
}