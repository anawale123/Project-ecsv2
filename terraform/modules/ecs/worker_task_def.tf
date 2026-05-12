resource "aws_ecs_task_definition" "worker_task_def" {
  family                   = "worker_service_ecs-${var.environment}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = var.ecs_pull
  task_role_arn            = var.worker_task_role

  container_definitions = jsonencode([
    {
      name      = "worker"
      image     = "703844615264.dkr.ecr.eu-west-2.amazonaws.com/worker_image"
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
        },
        {
          name  = "SQS_QUEUE_URL"
          value = "https://sqs.eu-west-2.amazonaws.com/703844615264/sqs-queue"
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
          "awslogs-stream-prefix" = "worker_task_${var.environment}"
        }
      }
    }
  ])

  tags = {
    Name        = "worker_task_def"
    Environment = var.environment
  }
}
