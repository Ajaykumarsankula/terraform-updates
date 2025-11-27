resource "aws_db_subnet_group" "db_subnets" {
  name        = "${var.env}-db-subnets"
  subnet_ids  = var.subnet_ids

  tags = {
    Name = "${var.env}-db-subnet-group"
  }
}

resource "aws_db_instance" "mysql" {
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = var.db_instance_class

  db_name                = var.db_name
  username               = var.db_user
  password               = var.db_password

  publicly_accessible    = false
  skip_final_snapshot    = true
  parameter_group_name   = "default.mysql8.0"

  db_subnet_group_name   = aws_db_subnet_group.db_subnets.name
  vpc_security_group_ids = [var.db_sg_id]

  tags = {
    Name = "${var.env}-mysql-rds"
  }
}