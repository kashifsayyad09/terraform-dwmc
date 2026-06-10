resource "aws_instance" "dev" {
  ami           = var.ami_id
  instance_type = var.instance_type
  count         = var.counts
  tags = {
    Name = var.name
  }
}
