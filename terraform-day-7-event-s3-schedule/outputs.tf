#############################################
# Outputs
#############################################

output "bucket_name" {
  value = aws_s3_bucket.lambda_bucket.bucket
}

output "lambda_name" {
  value = aws_lambda_function.example.function_name
}