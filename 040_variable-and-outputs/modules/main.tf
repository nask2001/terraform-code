
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
  count = var.NoofInstance

  ami           = var.ami_id
  instance_type = var.instance_type

  tags = {
    "Name" = "MyServer-${count.index}"
  }

}

output "Public-IP-address" {
  value = {

    for k, v in aws_instance.MyServer : k => v.public_ip
}
}

