data "aws_vpc" "main" {
  tags = {
    Name = "3-tietr-vpc"
  }
}
data "aws_subnet" "backend1" {
  vpc_id = data.aws_vpc.main.id
  tags = {
    Name = "prvt-5a"
  }
}

data "aws_subnet" "frontend1" {
  vpc_id = data.aws_vpc.main.id
  tags = {
    Name = "prvt-3a"
  }
}


resource "aws_instance" "backend" {
    ami           = "ami-0521cb2d60cfbb1a6"
    instance_type = "t3.micro"
    key_name      = "prod"
    subnet_id = data.aws_subnet.backend1.id
    tags = {
     Name = "backend" 
    }
}

resource "aws_instance" "frontend" {
    ami           = "ami-0521cb2d60cfbb1a6"
    instance_type = "t3.micro"
    key_name      = "prod"
    subnet_id = data.aws_subnet.frontend1.id
    tags = {
     Name = "frontend" 
    }
}

resource "null_resource" "dependencies-backend" {
provisioner "remote-exec" {
  
    connection {
      type = "ssh"
      host = aws_instance.backend.private_ip
      user = "ec2-user"
      private_key = file("prod.pem")
    }
inline = [
  "sudo yum update -y",
  "sudo yum install -y mariadb105-server",
  "sudo yum install -y python3-pip",
  "sudo yum install -y git",

  # Clone into ec2-user's home directory
  "cd ~ && git clone https://github.com/kashifsayyad09/ecommerce-shop-flask-3tire.git || true",

  # Debugging
  "pwd",
  "ls -la ~",
  "find ~ -name requirements.txt",

  # Install Python dependencies
  "cd ~/ecommerce-shop-flask-3tire/backend && pip3 install -r requirements.txt",

  "git --version"
]
}
triggers = {
  always_run = "${timestamp()}"
}
}

resource "null_resource" "dependencies-frontend" {
provisioner "remote-exec" {
  
    connection {
      type = "ssh"
      host = aws_instance.frontend.private_ip
      user = "ec2-user"
      private_key = file("prod.pem")
    }
inline = [
  "sudo yum update -y",
  "sudo yum install -y nginx git",

  "sudo systemctl enable nginx",
  "sudo systemctl start nginx",

  "cd ~ && git clone https://github.com/kashifsayyad09/ecommerce-shop-flask-3tire.git || true",

  "find ~ -type d -name frontend",

  "sudo rm -rf /usr/share/nginx/html/*",

  "sudo cp -r ~/ecommerce-shop-flask-3tire/frontend/* /usr/share/nginx/html/",

  "sudo cp -r ~/ecommerce-shop-flask-3tire/frontend/main/* /usr/share/nginx/html/",

  "sudo systemctl restart nginx",

  "git --version"
]
}
triggers = {
  always_run = "${timestamp()}"
}
}

