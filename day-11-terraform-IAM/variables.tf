variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Existing SSH keypair name in AWS"
  type        = string
  default     = "" # set to your keyname or pass via -var
}

variable "allowed_ssh_cidr" {
  description = "CIDR allowed to SSH"
  type        = string
  default     = "0.0.0.0/0" # change to your IP for safety
}