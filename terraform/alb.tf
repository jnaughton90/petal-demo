resource "aws_security_group" "alb_security_group" {
  name = "web-alb-sg"
  description = "Security group for web applications"
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "app_alb" {
  name = "petal-api-alb"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.alb_security_group.id]
  subnets = data.aws_subnets.all.ids
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

resource "aws_lb_target_group" "app_tg" {
  name     = "petal-api-service-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    enabled = true
    interval = 15
    matcher = "200"
    path = "/v1/sample"
    timeout = "10"
  }
}

output "dns_name" {
  value = aws_lb.app_alb.dns_name
}