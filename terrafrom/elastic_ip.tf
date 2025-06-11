resource "aws_eip" "minecraft_server_ip" {
  vpc = true
  
  tags = {
    Name = "Minecraft-Server-IP"
  }
}

resource "aws_eip_association" "minecraft_ip_assoc" {
  instance_id   = aws_instance.minecraft_server.id
  allocation_id = aws_eip.minecraft_server_ip.id
}
