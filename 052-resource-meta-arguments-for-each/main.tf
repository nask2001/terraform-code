
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
  for_each = {
      nano = "t2.nano"
      micro = "t2.micro"
      small = "t2.small"
  }
  
  ami           = "ami-0a3c14e1ddbe7f23c"
  instance_type = each.value

  tags = {
    "Name" = "MyServer-${each.key}"
  }
}

output "public-ip" {
  value = values(aws_instance.MyServer)[*].public_ip
}
