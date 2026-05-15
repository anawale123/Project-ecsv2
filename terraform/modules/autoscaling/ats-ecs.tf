# ECS Autoscaling Target
resource "aws_appautoscaling_target" "ecs_api" {
  max_capacity       = 4
  min_capacity       = 1
  resource_id        = "service/${var.cluster}/${var.service}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

# CloudWatch Alarm — Early Warning at 70%
resource "aws_cloudwatch_metric_alarm" "cpu_warning" {
  alarm_name          = "api-cpu-warning-${var.environment}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 60

  dimensions = {
    ClusterName = var.cluster
    ServiceName = var.service
  }

  tags = {
    Environment = var.environment
  }
}

# CloudWatch Alarm — Scale Out at 75%
resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "api-cpu-high-${var.environment}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 65

  dimensions = {
    ClusterName = var.cluster
    ServiceName = var.service
  }

  alarm_actions = [
    aws_appautoscaling_policy.cpu_scale_out.arn
  ]

  tags = {
    Environment = var.environment
  }
}

# CloudWatch Alarm — Scale In at 33%
resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = "api-cpu-low-${var.environment}"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 3
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 40

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

# Step Scaling — Scale Out (add 1 task when CPU > 75%)
resource "aws_appautoscaling_policy" "cpu_scale_out" {
  name               = "api-cpu-scale-out-${var.environment}"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.ecs_api.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_api.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_api.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }
}

# Step Scaling — Scale In (remove 1 task when CPU < 33%)
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
