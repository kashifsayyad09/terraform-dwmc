#############################################
# IAM Role for Lambda
#############################################

resource "aws_iam_role" "lambda_exec" {
  name = "lambda-exec-role"

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
# IAM Policy for Lambda
#############################################

resource "aws_iam_role_policy" "lambda_permissions" {
  name = "lambda-permissions"
  role = aws_iam_role.lambda_exec.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [

      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      },

      {
        Effect = "Allow"
        Action = [
          "ec2:CreateImage",
          "ec2:DescribeInstances",
          "ec2:DescribeImages",
          "ec2:CreateTags",
          "ec2:TerminateInstances"
        ]
        Resource = "*"
      }
    ]
  })
}

#############################################
# Lambda Function
#############################################

resource "aws_lambda_function" "my_lambda" {

  function_name = var.lambda_function_name

  role    = aws_iam_role.lambda_exec.arn
  handler = var.lambda_handler
  runtime = var.lambda_runtime
  timeout = var.lambda_timeout

  filename         = var.lambda_zip_file
  source_code_hash = filebase64sha256(var.lambda_zip_file)

  depends_on = [
    aws_iam_role_policy.lambda_permissions
  ]
}

#############################################
# EventBridge Rule
#############################################

resource "aws_cloudwatch_event_rule" "ec2_stopping_rule" {

  name        = "ec2-stopping-create-ami"
  description = "Trigger Lambda when EC2 enters stopping state"

  event_pattern = jsonencode({
    source = [
      "aws.ec2"
    ]

    detail-type = [
      "EC2 Instance State-change Notification"
    ]

    detail = {
      state = [
        "stopping"
      ]

      instance-id = [
        "i-04c19772444cd01dd"
      ]
    }
  })
}

#############################################
# EventBridge Target
#############################################

resource "aws_cloudwatch_event_target" "lambda_target" {

  rule      = aws_cloudwatch_event_rule.ec2_stopping_rule.name
  target_id = "CreateAMI"
  arn       = aws_lambda_function.my_lambda.arn
}

#############################################
# Allow EventBridge to Invoke Lambda
#############################################

resource "aws_lambda_permission" "allow_eventbridge" {

  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.my_lambda.function_name

  principal  = "events.amazonaws.com"
  source_arn = aws_cloudwatch_event_rule.ec2_stopping_rule.arn
}