# Output the IP address
output "minecraft_server_public_ip" {
  description = "Public IP Address of Minecraft Server"
  value = aws_eip.minecraft_server_ip.public_ip
}

# Output the instance id
output "minecraft_server_instance_id" {
  description = "Instance ID of Minecraft Server EC2 instance"
  value = aws_instance.minecraft_server.id
}