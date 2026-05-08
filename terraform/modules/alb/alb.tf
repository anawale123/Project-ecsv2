resource "aws_lb" "alb_main" {
  name               = "alb-main-${var.environment}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg]
  subnets            = var.public_subnets
  enable_deletion_protection = true

  access_logs {
    bucket  = var.s3_access_logs_alb
    prefix  = "alb"
    enabled = true
  }

  tags = {
    Environment = var.environment
    
  }
}