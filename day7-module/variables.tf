variable "db_name" {
  default = "mydatabase"
}

variable "username" {
  default = "admin"
}

variable "password" {
  default = "irumporaI@13"
}

variable "ami_id" {
    description = "passing ami values"
    default = ""
    type = string
  
}
variable "type" {
    description = "passing values to instance type"
    default = ""
    type = string
  
}
variable "create_ec2" {
  description = "Whether to create the EC2 instance"
  type        = bool
  default     = false
}
