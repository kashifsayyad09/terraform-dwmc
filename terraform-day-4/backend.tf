terraform {
  backend "s3" {
    bucket = "mybktterratf"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
