variable "vpc_cidr" {}
variable "public_subnet_cidr_1" {}
variable "public_subnet_cidr_2" {}
variable "availability_zone_1" {}
variable "availability_zone_2" {}

variable "instance_type" {}
variable "ami_id" {}

variable "env" {}
variable "region" {}

# RDS
variable "db_instance_class" {}
variable "db_name" {}
variable "db_user" {}
variable "db_password" { sensitive = true }

variable "db_sg_id" {}