resource "aws_instance" "name" {
  ami = "ami-0cb473a1f3c06c13d"
  instance_type = "t3.micro"
  #count = 3
  count = length(var.env)
  tags = {
    Name = var.env[count.index]
  }

}

