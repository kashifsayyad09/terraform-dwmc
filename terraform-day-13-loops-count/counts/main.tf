resource "aws_instance" "name" {
  ami = "ami-0521cb2d60cfbb1a6"
  instance_type = "t3.micro"
  #count = 3
  count = length(var.env)
  tags = {
    Name = var.env[count.index]
  }

}

