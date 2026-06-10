resource "aws_instance" "dev" {
  ami           = var.ami_id
  subnet_id     = var.subnet_id
  instance_type = var.instance_type
  count         = var.counts
  vpc_security_group_ids = [var.security_group_id]

  tags = {
    Name = var.name
  }
}