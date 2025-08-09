resource "aws_vpc" "demo-vpc" {
  cidr_block = var.cidr
}

resource "aws_subnet" "publicSubnet" {
  vpc_id                  = aws_vpc.demo-vpc.id
  cidr_block              = var.cidr_public
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "privateSubnet" {
  vpc_id                  = aws_vpc.demo-vpc.id
  cidr_block              = var.cidr_private
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = false
}

resource "aws_internet_gateway" "demo-igw" {
  vpc_id = aws_vpc.demo-vpc.id
}

resource "aws_route_table" "demo-rt" {
  vpc_id = aws_vpc.demo-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo-igw.id
  }
}

resource "aws_route_table_association" "rtas" {
  subnet_id      = aws_subnet.publicSubnet.id
  route_table_id = aws_route_table.demo-rt.id
}

resource "aws_security_group" "demo-sg" {
  name   = "web-sg-"
  vpc_id = aws_vpc.demo-vpc.id

  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    name = "web-sg"
  }
}

resource "aws_instance" "myec2-01" {
  ami                    = var.ami
  instance_type          = var.instance-type
  key_name               = "practise-ec2"
  vpc_security_group_ids = [aws_security_group.demo-sg.id]
  subnet_id              = aws_subnet.publicSubnet.id
  tags = {
    Name = "demoEC2"
  }
}



