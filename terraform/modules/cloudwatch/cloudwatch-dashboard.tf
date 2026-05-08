resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "ecs-app-dashboard-${var.environment}"

  dashboard_body = jsonencode({
    widgets = [
      # ECS CPU UTILISATION
      {
        type = "metric"
        properties = {
          title   = "ECS CPU Utilisation"
          region  = "eu-west-2"
          period  = 60
          stat    = "Average"
          metrics = [
            ["AWS/ECS", "CPUUtilization", "ServiceName", var.api_service_name, "ClusterName", var.cluster_name],
            ["AWS/ECS", "CPUUtilization", "ServiceName", var.dashboard_service_name, "ClusterName", var.cluster_name],
            ["AWS/ECS", "CPUUtilization", "ServiceName", var.worker_service_name, "ClusterName", var.cluster_name]
          ]
        }
      },

      # ECS MEMORY UTILISATION
      {
        type = "metric"
        properties = {
          title   = "ECS Memory Utilisation"
          region  = "eu-west-2"
          period  = 60
          stat    = "Average"
          metrics = [
            ["AWS/ECS", "MemoryUtilization", "ServiceName", var.api_service_name, "ClusterName", var.cluster_name],
            ["AWS/ECS", "MemoryUtilization", "ServiceName", var.dashboard_service_name, "ClusterName", var.cluster_name],
            ["AWS/ECS", "MemoryUtilization", "ServiceName", var.worker_service_name, "ClusterName", var.cluster_name]
          ]
        }
      },

      # ECS RUNNING TASK COUNT
      {
        type = "metric"
        properties = {
          title   = "ECS Running Task Count"
          region  = "eu-west-2"
          period  = 60
          stat    = "Average"
          metrics = [
            ["ECS/ContainerInsights", "RunningTaskCount", "ServiceName", var.api_service_name, "ClusterName", var.cluster_name],
            ["ECS/ContainerInsights", "RunningTaskCount", "ServiceName", var.dashboard_service_name, "ClusterName", var.cluster_name],
            ["ECS/ContainerInsights", "RunningTaskCount", "ServiceName", var.worker_service_name, "ClusterName", var.cluster_name]
          ]
        }
      },

      # ALB REQUEST COUNT
      {
        type = "metric"
        properties = {
          title   = "ALB Request Count"
          region  = "eu-west-2"
          period  = 60
          stat    = "Sum"
          metrics = [
            ["AWS/ApplicationELB", "RequestCount", "LoadBalancer", var.alb_arn_suffix]
          ]
        }
      },

      # ALB RESPONSE TIME
      {
        type = "metric"
        properties = {
          title   = "ALB Response Time"
          region  = "eu-west-2"
          period  = 60
          stat    = "Average"
          metrics = [
            ["AWS/ApplicationELB", "TargetResponseTime", "LoadBalancer", var.alb_arn_suffix]
          ]
        }
      },

      # ALB 5XX ERRORS
      {
        type = "metric"
        properties = {
          title   = "ALB 5XX Errors"
          region  = "eu-west-2"
          period  = 60
          stat    = "Sum"
          metrics = [
            ["AWS/ApplicationELB", "HTTPCode_Target_5XX_Count", "LoadBalancer", var.alb_arn_suffix]
          ]
        }
      },

      # SQS QUEUE DEPTH
      {
        type = "metric"
        properties = {
          title   = "SQS Queue Depth"
          region  = "eu-west-2"
          period  = 60
          stat    = "Average"
          metrics = [
            ["AWS/SQS", "ApproximateNumberOfMessagesVisible", "QueueName", "sqs-queue"],
            ["AWS/SQS", "ApproximateNumberOfMessagesVisible", "QueueName", "sqs-queue-dlq"]
          ]
        }
      },

      # SQS MESSAGES PROCESSED
      {
        type = "metric"
        properties = {
          title   = "SQS Messages Processed"
          region  = "eu-west-2"
          period  = 60
          stat    = "Sum"
          metrics = [
            ["AWS/SQS", "NumberOfMessagesDeleted", "QueueName", "sqs-queue"],
            ["AWS/SQS", "NumberOfMessagesSent", "QueueName", "sqs-queue"]
          ]
        }
      },

      # RDS CPU UTILIZATION
      {
        type = "metric"
        properties = {
          title   = "RDS CPU Utilization"
          region  = "eu-west-2"
          period  = 60
          stat    = "Average"
          metrics = [
            ["AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", var.db_identifier]
          ]
        }
      },

      # RDS DATABASE CONNECTIONS
      {
        type = "metric"
        properties = {
          title   = "RDS Database Connections"
          region  = "eu-west-2"
          period  = 60
          stat    = "Average"
          metrics = [
            ["AWS/RDS", "DatabaseConnections", "DBInstanceIdentifier", var.db_identifier]
          ]
        }
      },

      # RDS LATENCY
      {
        type = "metric"
        properties = {
          title   = "RDS Read/Write Latency"
          region  = "eu-west-2"
          period  = 60
          stat    = "Average"
          metrics = [
            ["AWS/RDS", "ReadLatency", "DBInstanceIdentifier", var.db_identifier],
            ["AWS/RDS", "WriteLatency", "DBInstanceIdentifier", var.db_identifier]
          ]
        }
      }
    ]
  })
}
