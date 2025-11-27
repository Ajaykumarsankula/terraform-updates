provider "aws" {
  region  = var.region
  profile = "dev"
}

module "vpc" {
  source = "../../modules/vpc"

  cidr_block            = var.vpc_cidr
  public_subnet_cidr_1  = var.public_subnet_cidr_1
  public_subnet_cidr_2  = var.public_subnet_cidr_2
  availability_zone_1   = var.availability_zone_1
  availability_zone_2   = var.availability_zone_2
  env                   = var.env
}

module "ec2" {
  source        = "../../modules/ec2"
  ami_id        = var.ami_id
  instance_type = var.instance_type
  env           = var.env

  subnet_id = module.vpc.public_subnet_id_1
}

module "rds" {
  source = "../../modules/rds"

  env               = var.env
  db_instance_class = var.db_instance_class
  db_name           = var.db_name
  db_user           = var.db_user
  db_password       = var.db_password

  db_sg_id = var.db_sg_id

  subnet_ids = [
    module.vpc.public_subnet_id_1,
    module.vpc.public_subnet_id_2
  ]

  region = var.region
}