
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

resource "aws_instance" "MyServer" {
  ami           = "ami-0a3c14e1ddbe7f23c"
  instance_type = "t2.micro"

  lifecycle {
    prevent_destroy = false
  }

  tags = {
    "Name" = "MyServer"
  }
}

output "public-ip" {
  value = aws_instance.MyServer.public_ip
}
