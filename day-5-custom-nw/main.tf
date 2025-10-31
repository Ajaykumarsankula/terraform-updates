
resource "aws_vpc" "name" {
    cidr_block = "10.0.0.0/16"
    tags = {
      Name="cust-vpc"
    }
  
}
resource "aws_subnet" "name" {
    cidr_block = "10.0.0.0/24"
    vpc_id = aws_vpc.name.id
    availability_zone = "us-east-1a"
    tags = {
      Name="pub-subnet-1"
    }
}
resource "aws_subnet" "name-2" {
    cidr_block = "10.0.1.0/24"
    vpc_id = aws_vpc.name.id
    availability_zone = "us-east-1b"
    tags = {
      Name="pvt-subnet-2"
    }
}

resource "aws_internet_gateway" "cust-ig" {
  vpc_id = aws_vpc.name.id
  tags = {
    Name="cust-ig"
  }
}

resource "aws_route_table" "name" {
  vpc_id = aws_vpc.name.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cust-ig.id
  }
}
resource "aws_route_table_association" "name" {
   subnet_id = aws_subnet.name.id
   route_table_id = aws_route_table.name.id
}

# Create SG
resource "aws_security_group" "cust_sg" {
  name   = "allow_tls"
  vpc_id = aws_vpc.name.id
  tags = {
    Name = "cust-sg"
  }
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
# Create sevrers  

resource "aws_instance" "public" {
    ami = var.ami_id
    instance_type = var.type
    subnet_id = aws_subnet.name.id
    vpc_security_group_ids = [ aws_security_group.cust_sg.id ]
    associate_public_ip_address = true
    tags = {
      Name = "public-ec2"
    }
  
}

resource "aws_instance" "pvt" {
    ami = var.ami_id
    instance_type = var.type
    subnet_id = aws_subnet.name.id
    vpc_security_group_ids = [ aws_security_group.cust_sg.id ]
   
    tags = {
      Name = "pvt-ec2"
    }
  
}
resource "aws_nat_gateway" "name" {
    subnet_id = aws_subnet.name.id
    allocation_id = aws_eip.name.id

    tags = {
      Name = "cust-nat"
    }
    
}
resource "aws_eip" "name" {
  domain = "vpc"
  tags = {
    Name = "eip-cust"
  }

}

resource "aws_route_table" "name-2" {
  vpc_id = aws_vpc.name.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.name.id
    
     }
     tags = {
       Name = "cust-nat-rt"
     }
}

resource "aws_route_table_association" "private_assoc" {
  subnet_id = aws_subnet.name-2.id
  route_table_id = aws_route_table.name-2.id
}