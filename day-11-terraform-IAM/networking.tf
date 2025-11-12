# Simple security group: SSH + HTTP
resource "aws_security_group" "web_sg" {
  name        = "example-web-sg"
  description = "Allow SSH and HTTP"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "example-web-sg"
  }
}

# Use default VPC and a public subnet (simple example)
data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "name" {
  vpc_id = data.aws_vpc.default.id
}

# Pick the first subnet
locals {
  subnet_id = data.aws_subnets.name.ids[0]
}

# Find Amazon Linux 2 AMI for region
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "web" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = local.subnet_id
  key_name               = var.key_name != "" ? var.key_name : null
  iam_instance_profile   = aws_iam_instance_profile.ec2_instance_profile.name
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl enable httpd
              systemctl start httpd
              echo "Hello from Terraform-created EC2 with IAM role" > /var/www/html/index.html
              EOF

  tags = {
    Name = "example-web-instance"
  }
}