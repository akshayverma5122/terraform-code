provider "aws" {
    region = var.aws_region
    
}


############################################################# Network Infrastructure For Server ######################################

resource "aws_vpc" "main_vpc" {
  cidr_block       = var.cidr_block["vpc_cidr"]
  instance_tenancy = "default"

  tags = {
    Name = var.tags[0]
  }
}

resource "aws_subnet" "main_subnet" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = var.cidr_block["subnet_cidr"]
  availability_zone = var.aws_az[1]

  tags = {
    Name = var.tags[0]
  }
}

resource "aws_default_route_table" "main_rt" {
  default_route_table_id = aws_vpc.main_vpc.default_route_table_id
  tags = {
    Name = var.tags[0]
  }
}

resource "aws_default_network_acl" "default" {
  default_network_acl_id = aws_vpc.main_vpc.default_network_acl_id

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = var.tags[0]
  }

}

resource "aws_default_security_group" "main_sg" {
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    protocol  = "TCP"
    from_port = 22
    to_port   = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = var.tags[0]
  }
}

resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = var.tags[0]
  }
}

resource "aws_route" "main_igw_route" {
  route_table_id            = aws_default_route_table.main_rt.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id  = aws_internet_gateway.main_igw.id
}


############################################################# Server Provisioning #####################################################

resource "aws_instance" "web" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id = aws_subnet.main_subnet.id
  monitoring = var.monitoring
  vpc_security_group_ids = [aws_default_security_group.main_sg.id]
  associate_public_ip_address = true
  key_name = "Master-Key"
  tags = {
    Name = var.tags[0]
  }
}





