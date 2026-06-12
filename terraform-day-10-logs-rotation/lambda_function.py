import boto3
from datetime import datetime, timedelta

logs_client = boto3.client('logs')

# ✅ MUST be EXACT log group name from CloudWatch
# Example format: /aws/ec2/ec2-all-logs
LOG_GROUP = "ec2-all-logs"
PREFIX = "cloudwatch-exports"

S3_BUCKET = "terraformyasgdjsadlhksh"


def lambda_handler(event, context):

    try:
        # last 24 hours time range
        end_time = datetime.utcnow()
        start_time = end_time - timedelta(days=1)

        start_ms = int(start_time.timestamp() * 1000)
        end_ms = int(end_time.timestamp() * 1000)

        print("Starting CloudWatch export task...")
        print(f"Log Group: {LOG_GROUP}")
        print(f"S3 Bucket: {S3_BUCKET}")

        response = logs_client.create_export_task(
            logGroupName=LOG_GROUP,
            fromTime=start_ms,
            to=end_ms,
            destination=S3_BUCKET,
            destinationPrefix=PREFIX
        )

        task_id = response["taskId"]

        print(f"Export task created successfully: {task_id}")

        return {
            "status": "SUCCESS",
            "taskId": task_id,
            "logGroup": LOG_GROUP,
            "bucket": S3_BUCKET
        }

    except Exception as e:
        print("ERROR:", str(e))

        return {
            "status": "FAILED",
            "error": str(e)
        }