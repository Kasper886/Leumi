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
  ami                    = "ami-07ab3281411d31d04"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]
  user_data = "${file("user_data.sh")}"
  
  tags = {
    Name  = "Web Server Build by Terraform"
    Owner = "Alex Largman"
  }

  lifecycle {
    create_before_destroy = true
  }
}