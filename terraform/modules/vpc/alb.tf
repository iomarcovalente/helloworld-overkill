resource "aws_lb" "main" {
  name               = join("", [var.stack_name,"-alb"])
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = aws_subnet.public.*.id

  enable_deletion_protection = false

  tags = {
    Name = join("", [var.stack_name,"-alb"])
  }
}

resource "aws_alb_target_group" "main" {
  name        = join("", [var.stack_name,"-tg"])
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/health"
    unhealthy_threshold = "2"
  }

  tags = {
    Name = join("", [var.stack_name,"-tg"])
  }
}

# Redirect to https listener
resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_lb.main.id
  port              = 80
  protocol          = "HTTP"

  default_action {
      target_group_arn = aws_alb_target_group.main.id
      type             = "forward"
  }
  # default_action {
  #   type = "redirect"

  #   redirect {
  #     port        = 443
  #     protocol    = "HTTPS"
  #     status_code = "HTTP_301"
  #   }
  # }
}

# Redirect traffic to target group
# resource "aws_alb_listener" "https" {
#     load_balancer_arn = aws_lb.main.id
#     port              = 443
#     protocol          = "HTTPS"

#     ssl_policy        = "ELBSecurityPolicy-2016-08"
#     certificate_arn   = var.alb_tls_cert_arn

#     default_action {
#         target_group_arn = aws_alb_target_group.main.id
#         type             = "forward"
#     }
# }

output "aws_alb_target_group_arn" {
  value = aws_alb_target_group.main.arn
}
