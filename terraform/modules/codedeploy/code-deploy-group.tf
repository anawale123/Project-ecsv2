resource "aws_codedeploy_deployment_group" "api_codedeploy" {
  app_name               = aws_codedeploy_app.api_codedeploy.name
  deployment_group_name  = "api-blue-green-${var.environment}"
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  service_role_arn       = var.codedeploy_role_arn

  ecs_service {
    cluster_name = var.cluster_name
    service_name = var.service_name_api
  }

  deployment_style {
    deployment_type   = "BLUE_GREEN"
    deployment_option = "WITH_TRAFFIC_CONTROL"
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout    = "CONTINUE_DEPLOYMENT"
      wait_time_in_minutes = 0
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = var.alb_listener
      }

      target_group {
        name = var.blue_api_codedeploy
      }

      target_group {
        name = var.green_api_tg
      }
    }
  }
}

resource "aws_codedeploy_deployment_group" "dashboard_codedeploy" {
  app_name               = aws_codedeploy_app.dashboard_codedeploy.name
  deployment_group_name  = "dashboard-blue-green-${var.environment}"
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  service_role_arn       = var.codedeploy_role_arn

  ecs_service {
    cluster_name = var.cluster_name
    service_name = var.service_name_dashboard
  }

  deployment_style {
    deployment_type   = "BLUE_GREEN"
    deployment_option = "WITH_TRAFFIC_CONTROL"
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout    = "CONTINUE_DEPLOYMENT"
      wait_time_in_minutes = 0
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = var.alb_listener
      }

      target_group {
        name = var.blue_codedeploy_dash
      }

      target_group {
        name = var.green_dashboard_tg
      }
    }
  }
}
