provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "web-server" {
  ami           = "ami-0685bcc683dadb6b9"
  instance_type = "t3.micro"
  tags = {
    Name = "Terraform-EC2"
  }
}