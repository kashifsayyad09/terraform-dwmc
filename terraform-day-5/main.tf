resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
    tags = {
        Name = "main-vpc"
    }
}

resource "aws_subnet" "a" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet_cidr_a
  availability_zone = var.az_1a
    tags = {
        Name = var.subnet_name1
    }
}

resource "aws_subnet" "c" {
    vpc_id     = aws_vpc.main.id
    cidr_block = var.subnet_cidr_c
    availability_zone =var.az_1c
        tags = {
            Name = var.subnet_name3
        }
}
