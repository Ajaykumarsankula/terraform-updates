variable "env" {
  type = string
}

variable "db_instance_class" {
  type = string
}

variable "db_name" {
  type = string
}

variable "db_user" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "db_sg_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "region" {
  type = string
}