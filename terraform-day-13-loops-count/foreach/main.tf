resource "aws_instance" "name" {
  for_each = var.instances

  ami           = "ami-0521cb2d60cfbb1a6"
  instance_type = each.value

  tags = {
    Name = each.key
  }
}