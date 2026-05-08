output "cluster_name" {
    value = aws_ecs_cluster.cluster_app.name
}

output "api_service_name" {
  value = aws_ecs_service.api_service_ecs.name
}

output "dashboard_service_name" {
  value = aws_ecs_service.dashboard_service_ecs.name
}

output "worker_service_name" {
  value = aws_ecs_service.worker_service_ecs.name
}

