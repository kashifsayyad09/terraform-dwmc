import boto3
from datetime import datetime

ec2 = boto3.client("ec2")

TARGET_INSTANCE_ID = "i-04c19772444cd01dd"


def lambda_handler(event, context):
    try:
        print("Received event:", event)

        instance_id = event["detail"]["instance-id"]

        # Process only the target instance
        if instance_id != TARGET_INSTANCE_ID:
            return {
                "statusCode": 200,
                "message": f"Ignoring instance {instance_id}"
            }

        ami_name = f"backup-{instance_id}-{datetime.utcnow().strftime('%Y%m%d-%H%M%S')}"

        # Create AMI
        response = ec2.create_image(
            InstanceId=instance_id,
            Name=ami_name,
            Description=f"Automated backup AMI for {instance_id}",
            NoReboot=True
        )

        ami_id = response["ImageId"]

        print(f"AMI creation initiated: {ami_id}")

        # Tag the AMI
        ec2.create_tags(
            Resources=[ami_id],
            Tags=[
                {
                    "Key": "Name",
                    "Value": ami_name
                },
                {
                    "Key": "CreatedBy",
                    "Value": "Lambda-Automation"
                }
            ]
        )

        print(f"Tagged AMI: {ami_id}")

        # WARNING:
        # This terminates the instance immediately after
        # AMI creation is initiated.
        ec2.terminate_instances(
            InstanceIds=[instance_id]
        )

        print(f"Termination initiated for {instance_id}")

        return {
            "statusCode": 200,
            "instance_id": instance_id,
            "ami_id": ami_id,
            "message": "AMI creation started and instance termination initiated."
        }

    except Exception as e:
        print(f"Error: {str(e)}")

        return {
            "statusCode": 500,
            "error": str(e)
        }