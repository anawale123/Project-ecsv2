# ecs cluster
resource "aws_ecs_cluster" "cluster_app" {
  name = "cluster-app-${var.environment}"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Environment = var.environment
  }
}