#############################################
# IAM Role for Lambda
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

resource "aws_s3_object" "lambda_zip" {
  bucket = "event-based-s3-zip"
  key    = "lambda_function.zip"
  source = "lambda_function.zip"

  etag = filemd5("lambda_function.zip")
}
#############################################
# Lambda Basic Execution Policy
#############################################

resource "aws_iam_role_policy_attachment" "lambda_logging" {
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

  s3_bucket = "event-based-s3-zip"
  s3_key    = "lambda_function.zip"

  depends_on = [
    aws_iam_role_policy_attachment.lambda_logging
  ]
}

#############################################
# EventBridge Rule - Every 5 Minutes
#############################################

resource "aws_cloudwatch_event_rule" "every_five_minutes" {
  name        = "every-five-minutes"
  description = "Trigger Lambda every 5 minutes"

  schedule_expression = "rate(5 minutes)"
}

#############################################
# EventBridge Target
#############################################

resource "aws_cloudwatch_event_target" "invoke_lambda" {
  rule      = aws_cloudwatch_event_rule.every_five_minutes.name
  target_id = "lambda"
  arn       = aws_lambda_function.example.arn
}

#############################################
# Permission for EventBridge to Invoke Lambda
#############################################

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"

  function_name = aws_lambda_function.example.function_name

  principal  = "events.amazonaws.com"
  source_arn = aws_cloudwatch_event_rule.every_five_minutes.arn
}