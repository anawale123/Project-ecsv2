# dashboard target group blue 
resource "aws_lb_target_group" "blue_dashboard_tg" {
  name        = "dashboard-tg-${var.environment}"
  port        = 8081
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/healthz"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-399"
  }

  tags = {
    Name        = "dashboard target group"
    Environment = var.environment
  }
}

# api target group blue
resource "aws_lb_target_group" "blue_api_tg" {
  name        = "api-tg-${var.environment}"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/healthz"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-399"
  }

  tags = {
    Name        = "api target group"
    Environment = var.environment
  }
}

# green target group dashboard
resource "aws_lb_target_group" "green_dashboard_tg" {
  name        = "green-dashboard-tg-${var.environment}"
  port        = 8081
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/healthz"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-399"
  }

  tags = {
    Name        = "dashboard target group"
    Environment = var.environment
  }
}

# api target  blue
resource "aws_lb_target_group" "green_api_tg" {
  name        = "green-api-tg-${var.environment}"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/healthz"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-399"
  }

  tags = {
    Name        = "api target group"
    Environment = var.environment
  }
}