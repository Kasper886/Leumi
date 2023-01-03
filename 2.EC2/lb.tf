locals {
  domain_name = "terraform-aws-modules.modules.tf"
}

module "nlb" {
  source             = "terraform-aws-modules/alb/aws"
  version            = "~> 8.0"
  name               = "my-nlb"
  load_balancer_type = "network"

  vpc_id             = aws_vpc.test-spoke-vpc.id
  subnets            = aws_subnet.public.*.id

   target_groups = [
    {
      name             = "web-tg"
      backend_protocol = "TCP"
      backend_port     = 80
      target_type      = "instance"
      depends_on       = [aws_instance.my_webserver]
    }
  ]

    http_tcp_listeners = [
     {
       port               = 80
       protocol           = "TCP"
       target_group_index = 0
     }
    ]

    tags = {
      Environment = "Web"
      Name  = "Web Server Build by Terraform"
      Owner = "Alex Largman"
    }
}

/*resource "aws_lb_target_group" "web-tg1" {
  name        = "web-tg"
  port        = 80
  protocol    = "HTTP"
  slow_start  = "0"
  depends_on  = [aws_instance.my_webserver]
  stickiness {
    cookie_duration = "86400"
    enabled         = "false"
    type            = "lb_cookie"
  }

  health_check {
    healthy_threshold   = "2"
    unhealthy_threshold = "2"
    interval            = "6"
    matcher             = "200,301,302"
    path                = var.health_check_path
    port                = "traffic-port"
    protocol            = "HTTP"
  }
}*/

/*resource "aws_lb_target_group_attachment" "web" {
  target_group_arn = aws_lb_target_group.web-tg.arn
  target_id        = aws_instance.my_webserver.id
  port             = 80
}*/