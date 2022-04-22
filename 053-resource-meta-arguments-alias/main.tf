
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.10.0"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

provider "aws" {
  profile = "default"
  region  = "us-west-1"
  alias   = "west"
}

data "aws_ami" "ami-ids" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}

data "aws_ami" "ami-west" {
  owners      = ["amazon"]
  most_recent = true
  provider    = aws.west

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "MyServer" {
  ami           = data.aws_ami.ami-ids.id
  instance_type = "t2.micro"
}

resource "aws_instance" "MyServer-01" {
  provider      = aws.west
  ami           = data.aws_ami.ami-west.id
  instance_type = "t2.micro"

}

output "EastServer-public-ip" {
  value = aws_instance.MyServer.public_ip
}

output "WestServer-public-ip" {
  value = aws_instance.MyServer-01.public_ip
}
