# ECS Autoscaling Target
resource "aws_appautoscaling_target" "ecs_api" {
  max_capacity       = 2
  min_capacity       = 1
  resource_id        = "service/${var.cluster}/${var.service}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

# CPU Scale Out (Target Tracking)
resource "aws_appautoscaling_policy" "cpu_scale_out" {
  name               = "api-cpu-scale-out-${var.environment}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_api.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_api.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_api.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = 30

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    scale_out_cooldown = 30
    scale_in_cooldown  = 120
  }
}

# CPU Scale In
resource "aws_appautoscaling_policy" "cpu_scale_in" {
  name               = "api-cpu-scale-in-${var.environment}"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.ecs_api.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_api.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_api.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 180
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }
}

# CloudWatch Alarm — Early Warning at 25%
resource "aws_cloudwatch_metric_alarm" "cpu_warning" {
  alarm_name          = "api-cpu-warning-${var.environment}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 25

  dimensions = {
    ClusterName = var.cluster
    ServiceName = var.service
  }

  tags = {
    Environment = var.environment
  }
}

# CloudWatch Alarm — Scale In at 35%
resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = "api-cpu-low-${var.environment}"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 35

  dimensions = {
    ClusterName = var.cluster
    ServiceName = var.service
  }

  alarm_actions = [
    aws_appautoscaling_policy.cpu_scale_in.arn
  ]

  tags = {
    Environment = var.environment
  }
}