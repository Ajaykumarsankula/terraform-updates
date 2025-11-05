import boto3
import os

s3 = boto3.client("s3")

def lambda_handler(event, context):
    bucket = os.environ["BUCKET_NAME"]
    key = "index.html"

    try:
        response = s3.get_object(Bucket=bucket, Key=key)
        content = response["Body"].read().decode("utf-8")
        print(f"✅ Content of {key}:")
        print(content)
        return {
            "statusCode": 200,
            "body": content
        }
    except Exception as e:
        print(f"❌ Error reading file: {e}")
        return {
            "statusCode": 500,
            "body": str(e)
        }
