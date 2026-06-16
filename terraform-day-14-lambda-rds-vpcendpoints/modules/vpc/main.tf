resource "aws_vpc" "main" {

  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "subnet1" {

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidr1
  availability_zone = var.az1

  tags = {
    Name = var.subnet_name1
  }
}

resource "aws_subnet" "subnet2" {

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidr2
  availability_zone = var.az2

  tags = {
    Name = var.subnet_name2
  }
}

resource "aws_route_table" "private" {

  vpc_id = aws_vpc.main.id

  tags = {
    Name = "private-route-table"
  }
}

resource "aws_route_table_association" "subnet1" {

  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "subnet2" {

  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.private.id
}
#no need of internet gateway for lambda and rds i'm using vpc endpoints

#resource "aws_internet_gateway" "gw" {
#  vpc_id = aws_vpc.name.id
#}

#resource "aws_route" "route" {
#  destination_cidr_block = "0.0.0.0/0"
#  gateway_id = aws_internet_gateway.gw.id
#  vpc_id = aws_vpc.name.id
#}
