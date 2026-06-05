resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "my-vpc"
  }
}

resource "aws_subnet" "subnet1" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.subnet1_cidr_block
  availability_zone = var.az1
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet-1"
  }
}

resource "aws_subnet" "subnet2" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.subnet2_cidr_block
  availability_zone = var.az2
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet-2"
  }
}

resource "aws_subnet" "subnet3" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.subnet3_cidr_block
  availability_zone = var.az1
  tags = {
    Name = "subnet-3"
  }
}

resource "aws_subnet" "subnet4" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.subnet4_cidr_block
  availability_zone = var.az2
  tags = {
    Name = "subnet-4"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "my-igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "public-rt"
  }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "subnet1_assoc" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "subnet2_assoc" {
  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.public_rt.id
}

# i wanna create regional nat gateway and private route table for subnet3 and subnet4

resource "aws_eip" "nat_eip" {
  domain = "vpc"
  tags = {
    Name = "nat-eip"
  }
}


resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.subnet1.id
  tags = {
    Name = "nat-gw"
  }
}

resource "aws_route_table" "pvt_rt" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "private-rt"
  }
}

resource "aws_route" "nat_route" {
  route_table_id         = aws_route_table.pvt_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw.id
}

resource "aws_route_table_association" "subnet3_assoc" {
  subnet_id      = aws_subnet.subnet3.id
  route_table_id = aws_route_table.pvt_rt.id
}

resource "aws_route_table_association" "subnet4_assoc" {
  subnet_id      = aws_subnet.subnet4.id
  route_table_id = aws_route_table.pvt_rt.id
}

resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow HTTP and SSH traffic"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.subnet1.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  #associate_public_ip_address = true
  tags = {
    Name = "web-server"
  }
}

resource "aws_instance" "app_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.subnet3.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  tags = {
    Name = "app-server"
  }
}

# i wanna create rds subnet group and rds instance in private subnet
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = [aws_subnet.subnet3.id, aws_subnet.subnet4.id]
  tags = {
    Name = "rds-subnet-group"
  }
}

resource "aws_db_instance" "my_rds" {
  identifier             = "my-rds-instance"
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = var.rds_instance_class
  db_name                = var.rds_db_name
  username               = var.rds_username
  password               = var.rds_password
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  skip_final_snapshot    = true
  tags = {
    Name = "my-rds-instance"
  }
}