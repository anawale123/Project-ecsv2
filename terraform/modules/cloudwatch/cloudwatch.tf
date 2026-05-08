resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/app/${var.environment}"
  retention_in_days = 7

  tags = {
    Environment = var.environment
  }
}