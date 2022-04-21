
module "server" {
  source        = "./modules"
  ami_id        = "ami-0a3c14e1ddbe7f23c"
  instance_type = "t2.micro"
  NoofInstance = 2
}

output "server_public_ip" {
  value = module.server.Public-IP-address
}
