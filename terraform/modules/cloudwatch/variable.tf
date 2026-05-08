variable "cluster_name" {
  description = "ECS cluster name"
  type        = string
}

variable "alb_arn_suffix" {
  description = "ALB ARN suffix for CloudWatch metrics"
  type        = string
}


variable "environment" {
  type = string
}

variable "api_service_name" {
  type = string
}

variable "dashboard_service_name" {
  type = string
}

variable "worker_service_name" {
  type = string
}

variable "sqs_queue_name" {
  type = string
}

variable "dlq_queue_name" {
  type = string
}

variable "db_identifier"{
  type = string
}