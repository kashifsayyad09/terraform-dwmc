resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_instance" "dev" {
  count         = var.count_id
  ami           = var.ami
  instance_type = var.instance_type
  tags = {
    Name = var.Name
  }
}