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

  tags = {
    "Name" = "MyServer-${local.project_name}"
  }
}

resource "null_resource" "status" {

  provisioner "local-exec" {

    command = "aws ec2 wait instance-status-ok --instance-ids ${aws_instance.my_server.id}"
  }

  depends_on = [
    aws_instance.my_server
  ]

}


output "public_ip" {
  value = aws_instance.my_server.public_ip
}
