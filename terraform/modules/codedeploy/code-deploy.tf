resource "aws_codedeploy_app" "api_codedeploy" {
  compute_platform = "ECS"
  name             = "api-codedeploy-${var.environment}"
}

resource "aws_codedeploy_app" "dashboard_codedeploy" {
  compute_platform = "ECS"
  name             = "dashboard-codedeploy-${var.environment}"
}