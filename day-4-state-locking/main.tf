resource "aws_instance" "name" { 
    instance_type = var.type
     ami = var.ami_id
     tags = {
       Name = "proddd33333333d"
     }


  
}
