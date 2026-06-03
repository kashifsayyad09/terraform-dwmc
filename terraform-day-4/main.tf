resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "a" {
  vpc_id     = aws_vpc.main.id
  availability_zone = var.az_b
  cidr_block = var.subnet_cidr_a
}

resource "aws_subnet" "b" {
  vpc_id     = aws_vpc.main.id
  availability_zone = var.az_a
  cidr_block = var.subnet_cidr_b
}