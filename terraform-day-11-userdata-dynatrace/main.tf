# i wanna add userdata script to this instance, how can i do that?
resource "aws_instance" "data" {
  ami                    = "ami-08f44e8eca9095668"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  user_data = <<-EOF
#!/bin/bash
set -xe

exec > >(tee /var/log/user-data.log)
exec 2>&1

yum update -y

cd /tmp


systemctl enable oneagent
systemctl start oneagent
EOF

  tags = {
    Name = "Dynatrace"
  }
}
#creating security group for allowing port 22 and 80
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH and HTTP traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
}
}

#i wanna import existing ec2 maunally created in aws console, how can i do that?
# Run: terraform import aws_instance.existing i-05e3b01f6d60a08d3

#resource "aws_s3_bucket" "my_bucket" {
#  bucket = "my-unique-bktdsbjjgkkmdlsme-12345"
#}
