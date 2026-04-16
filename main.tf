locals {
  name = "jenkins-lab"
}

#creating my vpc
resource "aws_vpc" "vpc-jenkins" {
  cidr_block       = var.vpc-cidr
  instance_tenancy = "default"

  tags = {
    Name = "vpc-jenkins"
  }
}

#creating my subnet
resource "aws_subnet" "pub-sub1" {
  vpc_id            = aws_vpc.vpc-jenkins.id
  cidr_block        = var.public-subnet1
  availability_zone = "eu-west-3a"
  map_public_ip_on_launch = true
  tags = {
    Name = "pub-sub1"
  }
}

#creating my internet gateway
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.vpc-jenkins.id

  tags = {
    Name = "IGW"
  }
}

#creating my public route table
resource "aws_route_table" "pub-rt" {
  vpc_id = aws_vpc.vpc-jenkins.id

  route {
    cidr_block = var.allcidr
    gateway_id = aws_internet_gateway.IGW.id
  }

  tags = {
    Name = "pub-rt"
  }
}

#creating my routetable assosciation
resource "aws_route_table_association" "Route-table-assosciation" {
  subnet_id      = aws_subnet.pub-sub1.id
  route_table_id = aws_route_table.pub-rt.id
}


resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "key" {
  content         = tls_private_key.key.private_key_pem
  filename        = "rowjenkey"
  file_permission = "0400"
}

resource "aws_key_pair" "key" {
  key_name   = "rowjenkey"
  public_key = tls_private_key.key.public_key_openssh
}

# creating security group
resource "aws_security_group" "jenkins-sg" {
  name        = "jenkins instance"
  description = "jenkins instance security group"
  vpc_id      = aws_vpc.vpc-jenkins.id

  ingress {
    description = "ssh from vpc"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allcidr]
  }

  ingress {
    description = "jenkins web"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [var.allcidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.allcidr]
  }

  tags = {
    Name = "${local.name}-jenkins-sg"
  }
}

# creating security group
resource "aws_security_group" "prod-sg" {
  name        = "prod sg"
  description = "prod instance security group"
  vpc_id      = aws_vpc.vpc-jenkins.id

  ingress {
    description = "ssh from vpc"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allcidr]
  }

  ingress {
    description = "http from vpc"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [var.allcidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.allcidr]
  }

  tags = {
    Name = "${local.name}-prod-sg"
  }
}

# creating jenkins instance
#creating jenkins instance
resource "aws_instance" "jenkins" {
  ami                         = var.redhat # jenkins redhat ami
  instance_type               = "t2.medium"
  key_name                    = aws_key_pair.key.id
  vpc_security_group_ids      = [aws_security_group.jenkins-sg.id]
  subnet_id                   = aws_subnet.pub-sub1.id
  associate_public_ip_address = true
  user_data                   = file("./userdata1.sh")

  tags = {
    Name = "${local.name}-jenkins"
  }
}

# creating prod instance
resource "aws_instance" "prod" {
  ami                         = var.redhat # jenkins redhat ami
  instance_type               = "t3.small"
  subnet_id                   = aws_subnet.pub-sub1.id
  key_name                    = aws_key_pair.key.id
  vpc_security_group_ids      = [aws_security_group.prod-sg.id]
  associate_public_ip_address = true
  user_data                   = file("./userdata2.sh")

  tags = {
    Name = "${local.name}-prod"
  }
}