# cloudwatfh log for ecs variable 
output "ecs_logs" {
  value = aws_cloudwatch_log_group.ecs_logs.name
}