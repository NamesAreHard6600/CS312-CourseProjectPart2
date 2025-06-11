resource "null_resource" "minecraft_provisioning" {
  triggers = {
    instance_id = aws_instance.minecraft_server.id
  }

  # File transfer
  provisioner "file" {
    source      = "../bash/setup.sh"
    destination = "/tmp/setup.sh"
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("../.ssh/minecraft_key")
      host        = aws_instance.minecraft_server.public_ip
    }
  }

  # Remote execution
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/setup.sh",
      "sudo /tmp/setup.sh",
      "rm /tmp/setup.sh"
    ]
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("../.ssh/minecraft_key")
      host        = aws_instance.minecraft_server.public_ip
    }
  }

  depends_on = [aws_security_group.minecraft_sg]
}