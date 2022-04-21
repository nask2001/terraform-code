variable "instance_type" {
  type    = string
  default = "t2.micro"
}

locals {
  project_name = "Senthil"
}

variable "vpc-cidr" {
  default = "10.0.0.0/16"
}

variable "public-cidr" {
  default = "10.0.0.0/24"
}
