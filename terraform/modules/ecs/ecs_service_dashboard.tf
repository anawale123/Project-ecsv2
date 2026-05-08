# ecs service dashboard
resource "aws_ecs_service" "dashboard_service_ecs" {
  name            = "dashboard-ecs-service-${var.environment}"
  cluster         = aws_ecs_cluster.cluster_app.id
  task_definition = aws_ecs_task_definition.dashboard_task_def.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [var.private_subnet]
    assign_public_ip = false
    security_groups  = [var.dashboard_sg]
  }

  load_balancer {
    target_group_arn = var.blue_dashboard_tg
    container_name   = "dashboard"
    container_port   = 8081
  }

  depends_on = [
    aws_ecs_task_definition.dashboard_task_def
  ]
  
    deployment_controller {
    type = "CODE_DEPLOY"
  }


  tags = {
    Name        = "dashboard-ecs-service"
    Environment = var.environment
  }
}
