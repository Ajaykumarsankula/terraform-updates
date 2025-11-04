resource "aws_db_instance" "default" {
  allocated_storage       = 10
  db_name                 = "mydb"
  identifier              = "rds-test"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  username                = "admin"
  password                = "Cloud123"
  db_subnet_group_name    = aws_db_subnet_group.sub-grp.id
  parameter_group_name    = "default.mysql8.0"

  # Enable backups and retention
  backup_retention_period  = 7   # Retain backups for 7 days
  backup_window            = "02:00-03:00" # Daily backup window (UTC)

  # Enable monitoring (CloudWatch Enhanced Monitoring)
  monitoring_interval      = 60  # Collect metrics every 60 seconds
  monitoring_role_arn      = aws_iam_role.rds_monitoring.arn

  # Enable performance insights
  # performance_insights_enabled          = true
  # performance_insights_retention_period = 7  # Retain insights for 7 days

  # Maintenance window
  maintenance_window = "sun:04:00-sun:05:00"  # Maintenance every Sunday (UTC)

  # Enable deletion protection (to prevent accidental deletion)
#    deletion_protection = "flase"

  # Skip final snapshot
  skip_final_snapshot = true
}

# # IAM Role for RDS Enhanced Monitoring
resource "aws_iam_role" "rds_monitoring" {
  name = "ajay-rds-monitoring-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "monitoring.rds.amazonaws.com"
      }
    }]
  })
}

#IAM Policy Attachment for RDS Monitoring
resource "aws_iam_role_policy_attachment" "rds_monitoring_attach" {
  role       = aws_iam_role.rds_monitoring.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}


# resource "aws_db_subnet_group" "sub-grp" {
#   name       = "mycutsubnet"
#   subnet_ids = ["subnet-05130d4ce6ae3f49f", "subnet-09136916c1425470b"]

#   tags = {
#     Name = "My DB subnet group"
#   }
# }




####### with data source ###########
data "aws_subnet" "subnet_1" {
  filter {
    name   = "tag:Name"
    values = ["subnet-1"]
  }
}

data "aws_subnet" "subnet_2" {
  filter {
    name   = "tag:Name"
    values = ["subnet-2"]
  }
}
resource "aws_db_subnet_group" "sub-grp" {
  name       = "mycutsubnet"
  subnet_ids = [data.aws_subnet.subnet_1.id, data.aws_subnet.subnet_2.id]

  tags = {
    Name = "My DB subnet group"
  }
}
resource "aws_db_instance" "read_replica" {
  identifier              = "rds-test-replica"
  replicate_source_db     = aws_db_instance.default.arn
  instance_class          = "db.t3.micro"
  db_subnet_group_name    = aws_db_subnet_group.sub-grp.id
  availability_zone       = "us-east-1c"
  skip_final_snapshot     = true
  monitoring_interval     = 60
  monitoring_role_arn     = aws_iam_role.rds_monitoring.arn

  tags = {
    Name = "rds-read-replica"
  }

  depends_on = [aws_db_instance.default]  # ensures primary DB exists first
}