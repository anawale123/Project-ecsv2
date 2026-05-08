# HTTP listener (redirect to HTTPS)
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb_main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  tags = {
    Name        = "http-listener"
    Environment = var.environment
    Project     = "url-shortener"
  }
}

# HTTPS listener
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.alb_main.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:eu-west-2:703844615264:certificate/c8820136-1ef5-4542-8870-e58fbac1a304"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue_api_tg.arn
  }

  tags = {
    Name        = "https-listener"
    Environment = var.environment
    Project     = "url-shortener"
  }
}

# API listener rule
resource "aws_lb_listener_rule" "api" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 20

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue_api_tg.arn
  }

  condition {
    path_pattern {
      values = ["/shorten", "/stats/*"]
    }
  }

  tags = {
    Name        = "api-rule"
    Environment = var.environment
    Project     = "url-shortener"
  }
}

# Dashboard listener rule
resource "aws_lb_listener_rule" "dashboard" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 21

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue_dashboard_tg.arn
  }

  condition {
    path_pattern {
      values = ["/summary", "/recent", "/top", "/url/*", "/healthz"]
    }
  }


  tags = {
    Name        = "dashboard-rule"
    Environment = var.environment
    Project     = "url-shortener"
  }
}