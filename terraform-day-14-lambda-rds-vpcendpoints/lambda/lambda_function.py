# import os
# import json
# import boto3
# import pymysql


# def get_secret():

#     secret_arn = os.environ["SECRET_ARN"]

#     client = boto3.client("secretsmanager")

#     response = client.get_secret_value(
#         SecretId=secret_arn
#     )

#     return json.loads(response["SecretString"])


# def lambda_handler(event, context):

#     try:

#         secret = get_secret()

#         connection = pymysql.connect(
#             host=secret["host"],
#             user=secret["username"],
#             password=secret["password"],
#             database="mydb",
#             port=3306,
#             connect_timeout=10
#         )

#         with connection.cursor() as cursor:

#             cursor.execute("SELECT NOW();")

#             result = cursor.fetchone()

#         connection.close()

#         return {
#             "statusCode": 200,
#             "body": json.dumps({
#                 "message": "Connected to RDS successfully",
#                 "server_time": str(result[0])
#             })
#         }

#     except Exception as e:

#         return {
#             "statusCode": 500,
#             "body": json.dumps({
#                 "error": str(e)
#             })
#         }

import os
import json
import boto3
import pymysql


def get_secret():

    secret_arn = os.environ["SECRET_ARN"]

    client = boto3.client("secretsmanager")

    response = client.get_secret_value(
        SecretId=secret_arn
    )

    return json.loads(response["SecretString"])


def lambda_handler(event, context):

    try:

        secret = get_secret()

        connection = pymysql.connect(
            host=secret["host"],
            user=secret["username"],
            password=secret["password"],
            database="mydb",
            port=3306,
            connect_timeout=10
        )

        with connection.cursor() as cursor:

            cursor.execute("SELECT NOW();")

            result = cursor.fetchone()

        connection.close()

        return {
            "statusCode": 200,
            "body": json.dumps({
                "message": "Connected to RDS successfully",
                "server_time": str(result[0])
            })
        }

    except Exception as e:

        return {
            "statusCode": 500,
            "body": json.dumps({
                "error": str(e)
            })
        }