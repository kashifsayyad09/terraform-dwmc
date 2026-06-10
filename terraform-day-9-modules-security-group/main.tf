resource "aws_security_group" "name" {
  vpc_id = var.vpc_id
  
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  /*ingress = {
    description = "HTTPS"
    from_port = 80
    to_port = 80
    protocol = "http"
    cidr_blocks = ["0.0.0.0/0"]
  }*/

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = var.sg-name
  }
}
