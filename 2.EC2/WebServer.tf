#------------------------------#
# Build WebServer by Terraform #
# with Bootstrap               #
#                              #
# Created: 02.01.2022          # 
# Owner: Alex Largman          #
# Email: alex@largman.pro      #
#------------------------------#

provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "my_webserver" {
  ami                    = "ami-0b5eea76982371e91"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.my_webserver.id]
  associate_public_ip_address = true
  user_data              = "${file("user_data.sh")}"
    
  tags = {
    Name  = "Web Server Build by Terraform"
    Owner = "Alex Largman"
  }

  lifecycle {
    create_before_destroy = true
  }
}