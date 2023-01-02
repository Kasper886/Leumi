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
  vpc_security_group_ids = [aws_security_group.my_webserver.id]
  user_data              = "${file("user_data.sh")}"
  
  tags = {
    Name  = "Web Server Build by Terraform"
    Owner = "Alex Largman"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "my_webserver" {
  name        = "WebServer Security Group"
  description = "Web Security Group"
  vpc_id      = aws_vpc.test-spoke-vpc.id
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "Web Server SecurityGroup"
    Owner = "Alex Largman"
  }
}