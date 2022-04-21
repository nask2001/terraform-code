terraform {
  /*  
  cloud {
    organization = "senthil-demo"

    workspaces {
      name = "provisioners"
    }
  }
  */
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.10.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
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

data "template_file" "user-data" {
  template = file("./userdata.yaml")
}