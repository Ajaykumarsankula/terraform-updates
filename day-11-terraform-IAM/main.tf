# IAM role for EC2
resource "aws_iam_role" "ec2_role" {
  name = "example-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
  tags = {
    Terraform = "true"
    Purpose   = "ec2-instance-role"
  }
}

# Custom inline policy (as standalone aws_iam_policy) - example: read S3 + CloudWatch logs
data "aws_caller_identity" "current" {}

resource "aws_iam_policy" "ec2_custom_policy" {
  name        = "example-ec2-custom-policy"
  description = "Allow read-only S3 and CloudWatch Logs write (example)"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "S3ReadOnly"
        Effect = "Allow"
        Action = [
          "s3:ListAllMyBuckets",
          "s3:GetBucketLocation",
          "s3:ListBucket",
          "s3:GetObject"
        ]
        Resource = ["arn:aws:s3:::*"]
      },
      {
        Sid    = "CloudWatchLogsPut"
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ]
        Resource = ["arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:*"]
      }
    ]
  })
}

# Attach the custom policy to the role
resource "aws_iam_role_policy_attachment" "attach_custom" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ec2_custom_policy.arn
}

# Also attach AWS-managed read-only S3 policy as example
resource "aws_iam_role_policy_attachment" "attach_managed_s3" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

# Instance profile so EC2 can assume the role
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "example-ec2-instance-profile"
  role = aws_iam_role.ec2_role.name
}