#i'm creating vpc and 2 subnets
resource "aws_vpc" "main"{
    cidr_block = var.vpc_cidr
    tags = {
        Name = var.vpc_name
    }
}

resource "aws_subnet" "subnet1" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.subnet_cidr1
  availability_zone = var.az1
  #subnet public true
  map_public_ip_on_launch = true
  tags = {
    name = "subnet-1"
  }
}

resource "aws_subnet" "subnet2" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.subnet_cidr2
  availability_zone = var.az1
  tags = {
   name = "subnet-2" 
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = var.igw_name
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "public-rt"
  }
}

resource "aws_route_table_association" "public_rt_assoc" {
  subnet_id = aws_subnet.subnet1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route" "default" {
  route_table_id = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.main.id
}
