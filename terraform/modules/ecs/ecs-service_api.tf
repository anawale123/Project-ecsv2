# ECS SERVICE (API)
resource "aws_ecs_service" "api_service_ecs" {
  name            = "api-ecs-service-${var.environment}"
  cluster         = aws_ecs_cluster.cluster_app.id
  task_definition = aws_ecs_task_definition.api_task_def.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [var.private_subnet]
    assign_public_ip = false
    security_groups  = [var.api_sg]
  }

  load_balancer {
    target_group_arn = var.blue_api_tg
    container_name   = "api"
    container_port   = 8080
  }

  lifecycle {
    ignore_changes = [task_definition, load_balancer]
  }

  depends_on = [
    aws_ecs_task_definition.api_task_def
  ]
    deployment_controller {
    type = "CODE_DEPLOY"
  }


  tags = {
    Name        = "api-service-ecs"   
    Environment = var.environment     

  }
}
