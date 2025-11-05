
resource "aws_db_instance" "rds" {
  identifier        = var.db_name
  engine            = "mysql"
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  username          = var.username
  password          = var.password
  skip_final_snapshot = true
}
resource "aws_instance" "name" { 
    count         = var.create_ec2 ? 1 : 0  # 👈 Only create if true
    instance_type = var.type
     ami = var.ami_id


}