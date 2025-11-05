provider "aws" {
  region = "us-east-1"
}

# 1️⃣ Create the Lambda function
resource "aws_lambda_function" "example" {
  function_name = "example-scheduled-lambda"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
  timeout       = 900
  memory_size   = 128

  filename         = "lambda_function.zip" # Path to your packaged code
  source_code_hash = filebase64sha256("lambda_function.zip")
  
  environment {
    variables = {
      BUCKET_NAME = "my-s3-bucket-ttttttttttt222222tttlllt"
    }
  }

  depends_on = [
    aws_s3_object.index_html
  ]
}

# 2️⃣ IAM Role for Lambda
resource "aws_iam_role" "lambda_exec" {
  name = "s3_lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# 3️⃣ Attach basic execution policy
resource "aws_iam_role_policy_attachment" "lambda_logging" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
resource "aws_iam_role_policy_attachment" "lambda_s3" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}
# 4️⃣ Create EventBridge rule (schedule)
resource "aws_cloudwatch_event_rule" "every_five_minutes" {
  name                = "every-five-minutes"
  description         = "Trigger Lambda every 5 minutes"
#   schedule_expression = "rate(5 minutes)"
  schedule_expression = "cron(0/5 * * * ? *)"

}

# 5️⃣ Add the Lambda target
resource "aws_cloudwatch_event_target" "invoke_lambda" {
  rule      = aws_cloudwatch_event_rule.every_five_minutes.name
  target_id = "lambda"
  arn       = aws_lambda_function.example.arn
}

# 6️⃣ Allow EventBridge to invoke the Lambda
resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.example.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.every_five_minutes.arn
}

module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "my-s3-bucket-ttttttttttt222222tttlllt"
  


  control_object_ownership = true
  object_ownership         = "BucketOwnerEnforced"

  versioning = {
    enabled = true
  }
}
resource "aws_s3_object" "index_html" {
  bucket = module.s3_bucket.s3_bucket_id
  key    = "index.html"
  source = "files/index.html"
  # acl    = "public-read"  # Optional, required if you're hosting a public site
  content_type = "text/html"
  depends_on = [module.s3_bucket]
}
