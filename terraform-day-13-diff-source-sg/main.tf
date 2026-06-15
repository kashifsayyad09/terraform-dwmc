resource "aws_security_group" "name" {
  name = "terraform-sec-group"
  description = "Allowing SSH and HTTP access from anywhere"
  
  dynamic "ingress"  {
    for_each = var.allowed_ports
    content {
       description = "Allow access to port ${ingress.key}"
       from_port = ingress.key
       to_port = ingress.key
       protocol = "tcp"
       cidr_blocks = [ingress.value]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-sec-group"
  }

 
}