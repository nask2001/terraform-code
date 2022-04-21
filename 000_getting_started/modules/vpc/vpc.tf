resource "aws_vpc" "demo" {
    cidr_block = var.cidr
    enable_dns_hostnames = true
  
  tags = {
    "Name" = "Demo-VPC"
  }
}
