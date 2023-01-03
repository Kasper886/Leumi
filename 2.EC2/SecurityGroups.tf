resource "aws_security_group" "my_webserver" {
  name        = "WebServer Security Group"
  description = "Web Security Group"
  vpc_id      = aws_vpc.test-spoke-vpc.id
  
  dynamic ingress {
    for_each = ["80", "443", "21", "22"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["91.231.246.50/32"]
    }
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

# LB Security Group:
resource "aws_security_group" "lb-sg" {
  name        = "LB Security Group"
  description = "Dynamic LB Security Group"
  vpc_id      = aws_vpc.test-spoke-vpc.id

  dynamic ingress {
    for_each = ["80", "443"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "LB-SG"
    Owner = "Alex Largman"
  }
}