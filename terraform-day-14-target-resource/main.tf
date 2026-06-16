resource "aws_instance" "example" {
  ami           = "ami-0521cb2d60cfbb1a6"
  instance_type = "t2.micro"
  tags = {
    Name = "terraform-example"
  }
}

resource "aws_s3_bucket" "example" {
  bucket = "terraform-example777"
}

resource "aws_vpc" "example" {
    cidr_block = "10.0.0.0/16"
}
