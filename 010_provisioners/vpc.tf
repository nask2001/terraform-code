data "aws_availability_zones" "available" {}

resource "aws_vpc" "myvpc" {
  cidr_block           = var.vpc-cidr
  enable_dns_hostnames = true

  tags = {
    "Name" = "My-VPC"
  }
}


resource "aws_internet_gateway" "igw" {

  vpc_id = aws_vpc.myvpc.id

  tags = {
    "Name" = "My-IGW"
  }
}

resource "aws_subnet" "public" {
  cidr_block              = var.public-cidr
  vpc_id                  = aws_vpc.myvpc.id
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[0]

  tags = {
    "Name" = "Public-Subnet"
  }
}

resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rta" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public-rt.id

}

resource "aws_security_group" "app-sg" {
  vpc_id      = aws_vpc.myvpc.id
  name        = "app-sg"
  description = "application security group"

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP"
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH"
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "outgoing connection"
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

}