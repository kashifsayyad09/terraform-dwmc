# resource "aws_instance" "name" {
#   ami = "ami-0521cb2d60cfbb1a6"
#   instance_type = "t2.micro"
#   count = var.dev ? 1 : 0
#   tags = {
#     Name = "terraform-aws-ec2"
#   }
# }

#if condition is true =1 dev instance
#if condition is false =0 blank value


# resource "aws_s3_bucket" "dev" {
#     bucket = "logroates3-cld"

# }    

resource "aws_instance" "example" {
  count         = var.environment == "prod" ? 3 : 1
  ami           = "ami-02dfbd4ff395f2a1b"
  instance_type = "t2.micro"

  tags = {
    Name = "example-${count.index}"
  }
}


