terraform {
  backend "s3" {
    bucket = "qwertsdh"
    key    = "terraform.tfstate"
    region = "us-east-1"
    use_lockfile = true
    #dynamodb_table = "grapes"
  }
}
