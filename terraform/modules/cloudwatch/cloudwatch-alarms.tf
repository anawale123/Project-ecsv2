
resource "aws_cloudwatch_metric_alarm" "api_cpu_high" {
  alarm_name          = "api-cpu-high-${var.environment}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 35
  alarm_description   = "API CPU utilisation above 35%"

  dimensions = {
    ServiceName = var.api_service_name
    ClusterName = var.cluster_name
  }

  tags = { 
    Environment = var.environment 
    }
}

resource "aws_cloudwatch_metric_alarm" "dashboard_cpu_high" {
  alarm_name          = "dashboard-cpu-high-${var.environment}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 70
  alarm_description   = "Dashboard CPU utilisation above 70%"

  dimensions = {
    ServiceName = var.dashboard_service_name
    ClusterName = var.cluster_name
  }

  tags = {
     Environment = var.environment 
     }
}

resource "aws_cloudwatch_metric_alarm" "worker_cpu_high" {
  alarm_name          = "worker-cpu-high-${var.environment}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 70
  alarm_description   = "Worker CPU utilisation above 70%"

  dimensions = {
    ServiceName = var.worker_service_name
    ClusterName = var.cluster_name
  }

  tags = {
     Environment = var.environment
      }
}

# ECS MEMORY ALARMS
resource "aws_cloudwatch_metric_alarm" "api_memory_high" {
  alarm_name          = "api-memory-high-${var.environment}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "API memory utilisation above 80%"

  dimensions = {
    ServiceName = var.api_service_name
    ClusterName = var.cluster_name
  }

  tags = { 
    Environment = var.environment 
    }
}

resource "aws_cloudwatch_metric_alarm" "dashboard_memory_high" {
  alarm_name          = "dashboard-memory-high-${var.environment}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Dashboard memory utilisation above 80%"

  dimensions = {
    ServiceName = var.dashboard_service_name
    ClusterName = var.cluster_name
  }

  tags = { 
    Environment = var.environment
     }
}

resource "aws_cloudwatch_metric_alarm" "worker_memory_high" {
  alarm_name          = "worker-memory-high-${var.environment}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Worker memory utilisation above 80%"

  dimensions = {
    ServiceName = var.worker_service_name
    ClusterName = var.cluster_name
  }

  tags = { 
    Environment = var.environment 
    }
}

# ALB ALARMS
resource "aws_cloudwatch_metric_alarm" "alb_5xx" {
  alarm_name          = "alb-5xx-${var.environment}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "HTTPCode_Target_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Sum"
  threshold           = 10
  alarm_description   = "ALB 5XX errors above 10"

  dimensions = {
    LoadBalancer = var.alb_arn_suffix
  }

  tags = { 
    Environment = var.environment
     }
}

resource "aws_cloudwatch_metric_alarm" "alb_4xx" {
  alarm_name          = "alb-4xx-${var.environment}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "HTTPCode_Target_4XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Sum"
  threshold           = 50
  alarm_description   = "ALB 4XX errors above 50"

  dimensions = {
    LoadBalancer = var.alb_arn_suffix
  }

  tags = { 
    Environment = var.environment 
    }
}

resource "aws_cloudwatch_metric_alarm" "alb_latency" {
  alarm_name          = "alb-latency-${var.environment}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "TargetResponseTime"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Average"
  threshold           = 2
  alarm_description   = "ALB response time above 2 seconds"

  dimensions = {
    LoadBalancer = var.alb_arn_suffix
  }

  tags = { 
    Environment = var.environment
     }
}

# SQS ALARMS
resource "aws_cloudwatch_metric_alarm" "sqs_queue_depth" {
  alarm_name          = "sqs-queue-depth-${var.environment}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "ApproximateNumberOfMessagesVisible"
  namespace           = "AWS/SQS"
  period              = 60
  statistic           = "Average"
  threshold           = 100
  alarm_description   = "SQS queue depth above 100 messages"

  dimensions = {
    QueueName = var.sqs_queue_name
  }

  tags = { 
    Environment = var.environment
     }
}

resource "aws_cloudwatch_metric_alarm" "dlq_depth" {
  alarm_name          = "dlq-depth-${var.environment}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "ApproximateNumberOfMessagesVisible"
  namespace           = "AWS/SQS"
  period              = 60
  statistic           = "Average"
  threshold           = 0
  alarm_description   = "DLQ has failed messages"

  dimensions = {
    QueueName = var.dlq_queue_name
  }

  tags = {
     Environment = var.environment
      }
}