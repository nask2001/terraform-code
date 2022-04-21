
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
}

resource "aws_s3_bucket" "bucket" {
  bucket = "my-tf-test-bucket-200420"

  depends_on = [
    aws_instance.MyServer
  ]
}

output "public-ip" {
  value = aws_instance.MyServer.public_ip
}
