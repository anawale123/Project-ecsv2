# api ecs task def
resource "aws_ecs_task_definition" "api_task_def" {
  family                   = "api-service-ecs-${var.environment}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = var.ecs_pull

  container_definitions = jsonencode([
    {
      name      = "api"
      image     = "703844615264.dkr.ecr.eu-west-2.amazonaws.com/api_image"
      cpu       = 256
      memory    = 512
      essential = true

      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
          protocol      = "tcp"
        }
      ]

      environment = [
        {
          name  = "HOSTNAME"
          value = "0.0.0.0"
        },
        {
          name  = "DATABASE_TYPE"
          value = "postgres"
        }
      ]

      secrets = [
        {
          name      = "DATABASE_URL"
          valueFrom = "arn:aws:secretsmanager:eu-west-2:703844615264:secret:DB_URL-CrV7Io"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = var.ecs_logs
          "awslogs-region"        = "eu-west-2"
          "awslogs-stream-prefix" = "api-task"
        }
      }
    }
  ])

  tags = {
    Name        = "api-task-def"
    Environment = var.environment
  }
}