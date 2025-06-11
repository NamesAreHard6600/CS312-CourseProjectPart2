# Version: 1.0.0

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.67.0"
    }
  }

  required_version = ">= 1.2.1"
}

# Key Pair
resource "aws_key_pair" "minecraft_key" {
  key_name   = var.key_name
  public_key = file("../.ssh/minecraft_key.pub")
}

# Find latest ubuntu 22.04 LTS AMI:
# I used this AMI because it's what I used in part 1
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

provider "aws" {
  region  = var.region
  shared_credentials_files = [var.aws_credentials_path]
}

resource "aws_instance" "minecraft_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.minecraft_key.key_name

  vpc_security_group_ids = [aws_security_group.minecraft_sg.id]

  root_block_device {
    volume_size = var.volume_size # 20 GiB default
    volume_type = "gp3"
  }

  tags = {
    Name = var.instance_name
  }
}

