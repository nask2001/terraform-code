terraform {
  cloud {
    organization = "senthil-demo"

    workspaces {
      name = "terraform-demo"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.10.0"
    }
  }
}

provider "aws" {
  #profile = "default"
  region  = "us-east-1"
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

variable "instance_type" {
  type = string
}

locals {
  project_name = "Senthil"
}

resource "aws_instance" "my_server" {
  ami           = data.aws_ami.ami-ids.id
  instance_type = var.instance_type

  tags = {
    "Name" = "MyServer-${local.project_name}"
  }
}

output "MyServer" {
  value = aws_instance.my_server.public_ip
}
