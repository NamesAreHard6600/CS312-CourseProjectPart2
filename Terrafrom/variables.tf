variable "instance_name" {
  description = "Name of EC2 instance"
  type        = string
  default     = "Minecraft-Server-2"
}

variable "key_name" {
  description = "Name of Key Pair on AWS"
  type        = string
  default     = "Minecraft-Key"
}

variable "sg_name" {
  description = "Name of Security Group"
  type        = string
  default     = "Minecraft-Server-Security-Group"
}

variable "region" {
  description = "AWS Region to use"
  type        = string
  default     = "us-west-2"
}

variable "instance_type" {
  description = "The type of instance to use"
  type        = string
  default     = "t3.small"
}

variable "volume_size" {
    description = "The amount of storage size to give it"
    type = number
    default = 20
}