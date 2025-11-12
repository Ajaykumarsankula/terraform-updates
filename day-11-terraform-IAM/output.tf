output "instance_id" {
  description = "EC2 instance id"
  value       = aws_instance.web.id
}

output "instance_public_ip" {
  description = "EC2 public IP"
  value       = aws_instance.web.public_ip
}

output "iam_role_name" {
  value = aws_iam_role.ec2_role.name
}