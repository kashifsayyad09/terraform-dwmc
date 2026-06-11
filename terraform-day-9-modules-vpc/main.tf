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
    name = "public-1"
  }
}

resource "aws_subnet" "subnet2" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.subnet_cidr2
  availability_zone = var.az2
  map_public_ip_on_launch = true
  tags = {
   name = "public-2" 
  }
}

resource "aws_subnet" "subnet3" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.subnet_cidr3
  availability_zone = var.az1
  tags = {
   name = "private-frontend-1" 
  }
} 

resource "aws_subnet" "subnet4" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.subnet_cidr4
  availability_zone = var.az2
  tags = {
   name = "private-frontend-2"
  }
}

resource "aws_subnet" "subnet5" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.subnet_cidr5
  availability_zone = var.az1
  tags = {
   name = "private-backend-1"
  }
}

resource "aws_subnet" "subnet6" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.subnet_cidr6
  availability_zone = var.az2
  tags = {
   name = "private-backend-2"
  }
}

resource "aws_subnet" "subnet7" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.subnet_cidr7
  availability_zone = var.az1
  tags = {
   name = "DB-1"
  }
}

resource "aws_subnet" "subnet8" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.subnet_cidr8
  availability_zone = var.az2
  tags = {
   name = "DB-2"
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

resource "aws_route_table_association" "public_assoc" {
  for_each = {
    subnet1 = aws_subnet.subnet1.id
    subnet2 = aws_subnet.subnet2.id
  }

  subnet_id      = each.value
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route" "default" {
  route_table_id = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.main.id
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"
  tags = {
    Name = "nat-eip"
  }
}

#i'm creating nat gateway regional level

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.subnet1.id

  tags = {
    Name = "nat-gateway"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "private-rt"
  }
}

resource "aws_route" "nat" {
  route_table_id = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat.id
}

resource "aws_route_table_association" "private_assoc" {
  for_each = {
    subnet3 = aws_subnet.subnet3.id
    subnet4 = aws_subnet.subnet4.id
    subnet5 = aws_subnet.subnet5.id
    subnet6 = aws_subnet.subnet6.id
    subnet7 = aws_subnet.subnet7.id
    subnet8 = aws_subnet.subnet8.id
  }

  subnet_id      = each.value
  route_table_id = aws_route_table.private_rt.id
}

