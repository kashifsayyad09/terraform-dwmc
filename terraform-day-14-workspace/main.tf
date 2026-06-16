resource "aws_instance" "name" {
    ami = "ami-0521cb2d60cfbb1a6"
    instance_type = "t2.micro"
    associate_public_ip_address = true
    tags = {
        Name = "terraform-prod"
    }
}