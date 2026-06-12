provider "aws" {
  region = "us-east-1"
}

#################################################
# IAM POLICY
#################################################

resource "aws_iam_policy" "admin" {
  name        = "ec2-admin-policy"
  description = "Admin access for EC2"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect   = "Allow"
        Action   = "*"
        Resource = "*"
      }
    ]
  })
}

#################################################
# IAM ROLE
#################################################

resource "aws_iam_role" "ec2_role" {
  name = "ec2-cloudwatch-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}

#################################################
# ATTACH ADMIN POLICY
#################################################

resource "aws_iam_role_policy_attachment" "admin_attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.admin.arn
}

#################################################
# CLOUDWATCH AGENT POLICY
#################################################

resource "aws_iam_role_policy_attachment" "cloudwatch_attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

#################################################
# INSTANCE PROFILE
#################################################

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-cloudwatch-profile"
  role = aws_iam_role.ec2_role.name
}

#################################################
# CLOUDWATCH LOG GROUP
#################################################

resource "aws_cloudwatch_log_group" "ec2_logs" {
  name              = "ec2-all-logs"
  retention_in_days = 7
}

#################################################
# EC2 INSTANCE
#################################################

resource "aws_instance" "ec2" {

  ami           = "ami-0c02fb55956c7d316" # Amazon Linux 2
  instance_type = "t3.micro"

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  user_data = <<-EOF
#!/bin/bash

yum update -y

yum install -y amazon-cloudwatch-agent

cat > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json <<CONFIG
{
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/messages",
            "log_group_name": "ec2-all-logs",
            "log_stream_name": "{instance_id}"
          }
        ]
      }
    }
  }
}
CONFIG

/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
-a fetch-config \
-m ec2 \
-c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json \
-s

systemctl enable amazon-cloudwatch-agent

EOF

  tags = {
    Name = "CloudWatch-EC2"
  }
}

resource "aws_s3_bucket" "example" {
  bucket = "terraformyasgdjsadlhksh"
}
#s3 + cloudwatch full acess for lambda function only

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

resource "aws_iam_role_policy_attachment" "lambda_policies" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/CloudWatchFullAccess"
  ])

  role       = aws_iam_role.lambda_exec.name
  policy_arn = each.value
}


resource "aws_lambda_function" "lambda_function" {
  function_name = "terraform-aws-ec2dsdsdr"
  filename      = "lambda_function.zip"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.8"
  source_code_hash = filebase64sha256("lambda_function.zip")
}

resource "aws_lambda_permission" "lambda_permission" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.function_name
  principal     = "s3.amazonaws.com"
}

#################################################
# OUTPUTS
#################################################

output "instance_id" {
  value = aws_instance.ec2.id
}

output "public_ip" {
  value = aws_instance.ec2.public_ip
}
