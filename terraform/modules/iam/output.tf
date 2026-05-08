# ecs execution output variable 
output "ecs_pull" {
    value       = aws_iam_role.ecs_execution_role.arn
     description = "IAM role for pulling images from ECR"
}

output "worker_task_role" {
  value = aws_iam_role.worker_task_role.arn
}

output "codedeploy_role_arn" {
  value = aws_iam_role.code_deploy_service_role.arn
}