provider "aws" {
  
}

resource "aws_key_pair" "name" {
    key_name = "test"
    public_key = file("~/.ssh/id_ed25519.pub")
  
}


resource "aws_instance" "name" {
    ami="ami-07860a2d7eb515d9a"
    instance_type = "t3.micro"
    key_name = aws_key_pair.name.key_name
    associate_public_ip_address = true
   tags={
    Name="rds"
   }
}

 #Create the RDS instance

resource "aws_db_instance" "mysql_rds" {
  identifier              = "my-mysql-db"
  engine                  = "mysql"
  instance_class          = "db.t3.micro"
  username                = "admin"
  password                = "RRpati23"
  db_name                 = "dev"
  allocated_storage       = 20
  skip_final_snapshot     = true
  publicly_accessible     = true
}

#---------------null-resources--------#

resource "null_resource" "name" {
  depends_on = [aws_db_instance.mysql_rds, aws_instance.name]

  #SSH Connection to EC2
  connection {
    type        = "ssh"
    user        = "ec2-user"
    host        = aws_instance.name.public_ip
    private_key = file("~/.ssh/id_ed25519")
  }

  # Copy the SQL file from your local machine to EC2
  provisioner "file" {
    source      = "test.sql"                 # path on your local machine
    destination = "/home/ec2-user/test.sql"  # path on EC2
  }

  # 3Run MySQL command remotely inside EC2

  provisioner "remote-exec" {
    inline = [
      # Install MySQL client if missing
      "sudo yum install -y mariadb105-server",

      # Run the SQL file on your RDS instance
      "mysql -h ${aws_db_instance.mysql_rds.address} -u admin -pRRpati23 dev < /home/ec2-user/test.sql"
    ]
  }
}