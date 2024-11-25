resource "aws_instance" "publicinstance" {
  ami           = data.aws_ami.amlin.id
  instance_type = var.instance_type
  key_name = "terraform-key"
  user_data = file("apache-install.sh")
   vpc_security_group_ids = [aws_security_group.publicsg.id]
   
   tags = {
    Name = "publicinstance"
  }

provisioner "file" {
      source = "apps/file-copy.html"
        destination = "/tmp/file-copy.html"
}

  provisioner "remote-exec" {
    inline = [
      "sleep 120",
      "sudo cp /tmp/file-copy.html /var/www/html/",
      "sudo chmod 644 /var/www/html/file-copy.html"
    ]
  }

connection {
            type = "ssh"
            host = self.public_ip
            user = "ec2-user"
            private_key = file("private-key/terraform-key.pem")
        }
}

