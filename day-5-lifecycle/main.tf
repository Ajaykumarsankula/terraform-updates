resource "aws_instance" "name" { 
    instance_type = var.type
     ami = var.ami_id
     tags = {
       Name = "prodddd222222"
}

 lifecycle {
      create_before_destroy = true
      ignore_changes = [tags]
     prevent_destroy = true
    }
  
 # lifecycle {
    #   create_before_destroy = true
    # }
    # lifecycle {
    #   ignore_changes = [tags,  ]
    # }
    # lifecycle {
    #   prevent_destroy = true
    # }
  
  
}
