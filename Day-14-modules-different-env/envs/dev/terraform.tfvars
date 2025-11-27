vpc_cidr             = "10.0.0.0/16"
public_subnet_cidr_1 = "10.0.5.0/24"
public_subnet_cidr_2 = "10.0.2.0/24"

availability_zone_1 = "us-east-1a"
availability_zone_2 = "us-east-1b"

instance_type = "t3.micro"
ami_id        = "ami-0cae6d6fe6048ca2c"

env    = "dev"
region = "us-east-1"

db_instance_class = "db.t3.micro"
db_name           = "devdb"
db_user           = "admin"
db_password       = "DevPassword123!"

db_sg_id = "sg-027595551db2c46c8"