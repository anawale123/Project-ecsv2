# ecs service worker
resource "aws_ecs_service" "worker_service_ecs" {
  name            = "worker-ecs-service-${var.environment}"
  cluster         = aws_ecs_cluster.cluster_app.id
  task_definition = aws_ecs_task_definition.worker_task_def.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [var.private_subnet]
    assign_public_ip = false
    security_groups  = [var.worker_sg]
  }

  depends_on = [
    aws_ecs_task_definition.worker_task_def
  ]

  tags = {
    Name        = "worker-ecs-service"   
    Environment = var.environment       
  }
}
