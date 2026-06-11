resource "aws_s3_bucket" "name" {
  bucket = "youronewhomakeit"
}

resource "aws_s3_bucket_versioning" "name" {
  bucket = aws_s3_bucket.name.id
  versioning_configuration {
    status = "Enabled"
  }
}

/*resource "aws_s3_bucket_acl" "name" {
  bucket = aws_s3_bucket.name.id
  acl    = var.bucket_acl
}*/

resource "aws_s3_bucket_ownership_controls" "name" {
  bucket = aws_s3_bucket.name.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "name" {
  depends_on = [aws_s3_bucket_ownership_controls.name]

  bucket = aws_s3_bucket.name.id
  acl    = "private"
}