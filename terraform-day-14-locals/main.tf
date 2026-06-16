locals {
    region = "us-east-1"
    ami_id = "ami-0521cb2d60cfbb1a6"
    instance_type = "t2.micro"

}

resource "aws_instance" "name" {
  ami = local.ami_id
  instance_type = local.instance_type
}