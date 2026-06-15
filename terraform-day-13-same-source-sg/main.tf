resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "main" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_security_group" "main" {
  vpc_id = aws_vpc.main.id
  name = "main"
  description = "main security group"
  tags = {
    Name = "main"
  }
  ingress = [
    for port in var.sg_rule : {

      description = "sg_rule adding by variable"
      from_port = port
      to_port = port   
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      self = false
      security_groups   = []
    }
  ]
}

