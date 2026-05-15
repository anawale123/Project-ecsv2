# ECS Autoscaling Target
resource "aws_appautoscaling_target" "ecs_api" {
  max_capacity       = 4
  min_capacity       = 2   # ← CRITICAL: prevents instant CPU spike on 1 task
  resource_id        = "service/${var.cluster}/${var.service}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

# TargetTracking — CPU Maintain 60%
resource "aws_appautoscaling_policy" "cpu_target_tracking" {
  name               = "api-cpu-targettracking-${var.environment}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_api.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_api.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_api.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = 60   # ← CPU target (adjust if needed)

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    scale_out_cooldown = 30   # ← fast reaction
    scale_in_cooldown  = 120  # ← prevents flapping
  }
}
