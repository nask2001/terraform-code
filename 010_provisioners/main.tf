resource "aws_key_pair" "key" {
  key_name   = "mykey"
  public_key = file("mykey.pub")

}


resource "aws_instance" "my_server" {
  ami                    = data.aws_ami.ami-ids.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.key.key_name
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.app-sg.id]
  user_data              = data.template_file.user-data.rendered

  provisioner "local-exec" {
    command = "echo ${self.private_ip} >> private_ips.txt"
  }

  provisioner "file" {
    content     = "Hi, How are you "
    destination = "text.txt"

    connection {
      user        = "ec2-user"
      host        = self.public_ip
      type        = "ssh"
      private_key = file("mykey")
    }

  }
  provisioner "remote-exec" {
    inline = [
      "echo ${self.private_ip} >> private_ips.txt"
    ]

    connection {
      user        = "ec2-user"
      host        = self.public_ip
      type        = "ssh"
      private_key = file("mykey")
    }

  }

  tags = {
    "Name" = "MyServer-${local.project_name}"
  }
}

output "public_ip" {
  value = aws_instance.my_server.public_ip
}
