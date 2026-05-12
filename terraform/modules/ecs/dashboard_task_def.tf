# dashboard task def s
resource "aws_ecs_task_definition" "dashboard_task_def" {
  family                   = "dashboard-service-ecs-${var.environment}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = var.ecs_pull

  container_definitions = jsonencode([
    {
      name      = "dashboard"
      image     = "703844615264.dkr.ecr.eu-west-2.amazonaws.com/dashboard_image:latest"
      cpu       = 256
      memory    = 512
      essential = true

      portMappings = [
        {
          containerPort = 8081
          hostPort      = 8081
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
             name      = "DATABASE_URL",
              valueFrom = "arn:aws:secretsmanager:eu-west-2:703844615264:secret:DB_URL-CrV7Io:DATABASE_URL::"
          }
        ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = var.ecs_logs
          "awslogs-region"        = "eu-west-2"
          "awslogs-stream-prefix" = "dashboard-task"
        }
      }
    }
  ])

  tags = {
    Name        = "dashboard-task-def"
    Environment = var.environment
  }
}
