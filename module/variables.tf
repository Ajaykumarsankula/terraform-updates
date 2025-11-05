variable "aws_region" {
  description = "AWS region to deploy resources in"
  type        = string
  default     = ""
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = ""
}

variable "environment" {
  description = "Deployment environment (e.g. dev, prod)"
  type        = string
  default     = ""
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "availability_zone" {
  description = "Availability zone for subnet"
  type        = string
  default     = "us-east-1a"
}

variable "ami_id" {
  description = "AMI ID for EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = ""
}

variable "key_name" {
  description = "SSH key name for EC2 access"
  type        = string
  default = ""
}

variable "db_name" {
  description = "Database name for RDS"
  type        = string
  default     = ""
}

variable "db_username" {
  description = "Master username for RDS"
  type        = string
  default     = ""
}

variable "db_password" {
  description = "Master password for RDS"
  type        = string
  sensitive   = true
   default = ""
}
