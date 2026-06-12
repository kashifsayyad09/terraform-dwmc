resource "aws_key_pair" "mykey" {
  key_name = "production"
  public_key = file("~/.ssh/id_ed25519.pub")
}

resource "aws_security_group" "mysecgroup" {
  #vpc_id = "vpc-05550542a60b9e982"
  name = "mysecgroup"
  description = "Allow SSH access from anywhere"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "my-sg-t"
  }
}



resource "aws_instance" "name" {
  ami = "ami-0c02fb55956c7d316"
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.mysecgroup.id]
  key_name = aws_key_pair.mykey.key_name
  associate_public_ip_address = true
  tags = {
    Name = "my-ec2-t"
  }
  # connection {
  #   type = "ssh"
  #   user = "ec2-user"
  #   private_key = file("~/.ssh/id_ed25519")
  #   host = self.public_ip
  #   timeout = "2m"
  # }

# provisioner "file" {
#     source = "veera.txt"
#     destination = "/home/ec2-user/veera.txt"
#   }

# provisioner "remote-exec" {
#   inline = [
#     "sudo yum update -y",
#     "sudo yum install -y git",
#     "git --version"
#   ]
# }
#   provisioner "local-exec" {
#     command = "touch ali.txt"
#   }
}

resource "null_resource" "run_script" {
 provisioner "remote-exec" {
   connection {
     type = "ssh"
     host = aws_instance.name.public_ip
     user = "ec2-user"
     private_key = file("~/.ssh/id_ed25519")
   }
   inline = [
     "sudo yum update -y",
     "sudo yum install -y git",
     "git --version"
   ]
 }
 triggers = {
  always_run = "${timestamp()}"
 } 
}

