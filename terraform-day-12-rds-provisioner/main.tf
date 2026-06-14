resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "subnet1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "subnet2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1b"
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_route_table_association" "main1" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.main.id
}

resource "aws_route_table_association" "main2" {
  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.main.id
}

#creation security group rds and ec2 

resource "aws_security_group" "rds" {
  vpc_id = aws_vpc.main.id
  name        = "rds"
  description = "Allow all inbound and outbound traffic"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
}
}

resource "aws_security_group" "ec2" {
  vpc_id = aws_vpc.main.id
  name        = "ec2"
  description = "Allow all inbound and outbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
}
}
#creation of rds subnet-group

resource "aws_db_subnet_group" "main" {
  name       = "main"
  subnet_ids = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
}

#creation of rds instance 8.0
resource "aws_db_instance" "main" {
  db_name                = "main"
  allocated_storage      = 20
  instance_class         = "db.t3.micro"
  engine                 = "mysql"
  engine_version         = "8.0"
  username               = "admin"
  password               = "admin1234"
  parameter_group_name   = "default.mysql8.0"
  skip_final_snapshot    = true 
  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.main.name
}

#creation of ec2 instance

#i'm add my own public key to the key pair
resource "aws_key_pair" "terraform" {
  key_name   = "terraform"
  public_key = file("~/.ssh/id_ed25519.pub")
}

resource "aws_instance" "main" {
  ami                    = "ami-0521cb2d60cfbb1a6"
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.terraform.key_name
  vpc_security_group_ids = [aws_security_group.ec2.id]
  subnet_id              = aws_subnet.subnet1.id
}

#provisioners 

resource "null_resource" "provisioner" {
  connection {
    type        = "ssh"
    host        = self.id
    user        = "ubuntu"
    private_key = file("~/.ssh/id_ed25519")
  }
  provisioner "file" {
    source = "test.sql"
    destination = "/tmp/test.sql"
  }
  provisioner "remote-exec" {
    inline = [ 
        "sudo yum update -y",
        "sudo yum install -y mariadb105-server",
        "mysql -h ${aws_db_instance.main.endpoint} -u ${aws_db_instance.main.username} -p${aws_db_instance.main.password} < /tmp/test.sql"
     ]
  }

  triggers = {
    always_run = timestamp()
  }

}