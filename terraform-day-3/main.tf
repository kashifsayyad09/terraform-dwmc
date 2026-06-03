resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name        = "main-vpc"
    Environment = var.environment
    Owner       = var.owner
  }
}

resource "aws_subnet" "a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidr_a
  availability_zone = var.subnet_az_a
  tags              = { Name = "subnet-a" }
}

resource "aws_subnet" "b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidr_b
  availability_zone = var.subnet_az_b
  tags              = { Name = "subnet-b" }
}

resource "aws_subnet" "c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidr_c
  availability_zone = var.subnet_az_c
  tags              = { Name = "subnet-c" }
}

resource "aws_subnet" "d" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidr_d
  availability_zone = var.subnet_az_d
  tags              = { Name = "subnet-d" }
}
