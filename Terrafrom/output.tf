# Output the IP address
output "minecraft_server_public_ip" {
  description = "Public IP Address of Minecraft Server"
  value = aws_instance.minecraft_server.public_ip
}