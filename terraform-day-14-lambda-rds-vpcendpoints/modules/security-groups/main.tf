resource "aws_security_group" "lambda_sg" {

  name        = "lambda-sg"
  description = "Security Group for Lambda"
  vpc_id      = var.vpc_id

  egress {

    from_port   = 0
    to_port     = 0
    protocol    = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "lambda-sg"
  }
}

resource "aws_security_group" "rds_sg" {

  name        = "rds-sg"
  description = "Security Group for RDS"
  vpc_id      = var.vpc_id

  ingress {

    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"

    security_groups = [
      aws_security_group.lambda_sg.id
    ]
  }

  egress {

    from_port   = 0
    to_port     = 0
    protocol    = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-sg"
  }
}

resource "aws_security_group" "vpce_sg" {

  name        = "vpce-sg"
  description = "Security Group for Secrets Manager VPC Endpoint"
  vpc_id      = var.vpc_id

  ingress {

    from_port       = 443
    to_port         = 443
    protocol        = "tcp"

    security_groups = [
      aws_security_group.lambda_sg.id
    ]
  }

  egress {

    from_port   = 0
    to_port     = 0
    protocol    = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "vpce-sg"
  }
}