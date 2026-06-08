#############################################
# S3 Bucket
#############################################

resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "event-based-s3-zip"
}

#############################################
# Upload Lambda ZIP
#############################################

resource "aws_s3_object" "lambda_zip" {
  bucket = aws_s3_bucket.lambda_bucket.id
  key    = "lambda_function.zip"
  source = "${path.module}/lambda_function.zip"

  etag = filemd5("${path.module}/lambda_function.zip")
}

#############################################
# IAM Role
#############################################

resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "lambda.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}

#############################################
# CloudWatch Logs Permissions
#############################################

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

#############################################
# Lambda Function
#############################################

resource "aws_lambda_function" "example" {
  function_name = "example-scheduled-lambda"

  role    = aws_iam_role.lambda_exec.arn
  handler = "lambda_function.lambda_handler"
  runtime = "python3.13"

  timeout     = 900
  memory_size = 128

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.lambda_zip.key

  depends_on = [
    aws_s3_object.lambda_zip,
    aws_iam_role_policy_attachment.lambda_basic
  ]
}

#############################################
# EventBridge Rule Every 5 Minutes
#############################################

resource "aws_cloudwatch_event_rule" "every_five_minutes" {
  name                = "every-five-minutes"
  description         = "Run Lambda every 5 minutes"
  schedule_expression = "cron(0/5 * * * ? *)"
}

#############################################
# EventBridge Target
#############################################

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.every_five_minutes.name
  target_id = "LambdaTarget"
  arn       = aws_lambda_function.example.arn
}

#############################################
# Lambda Permission
#############################################

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.example.function_name

  principal  = "events.amazonaws.com"
  source_arn = aws_cloudwatch_event_rule.every_five_minutes.arn
}

#############################################
# Outputs
#############################################

output "bucket_name" {
  value = aws_s3_bucket.lambda_bucket.bucket
}

output "lambda_name" {
  value = aws_lambda_function.example.function_name
}