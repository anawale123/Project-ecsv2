# vpc id variable
variable "vpc_id" {
  description = "VPC ID where ECS resources will be deployed"
  type        = string
}

# private subnet id variable
variable "private_subnet" {
  description = "List of private subnet IDs for ECS tasks"
  type        = string
}

# api security group
variable "api_sg" {
  description = "Security group for api ecs"
  type        = string
}

# dashboard security group
variable "dashboard_sg" {
  description = "Security group ID for dashboard ECS tasks"
  type        = string
}

# worker security group
variable "worker_sg" {
  description = "Security group ID for worker ECS tasks"
  type        = string
}


#  alb reference 
variable "alb_arn" {
    type     = string 
    description = "alb aws reference"
}

#  alb tg api blue 
variable "blue_api_tg" {
    type     = string 
    description = "alb api live blue tg aws reference"
}

#  alb tg dashboard blue 
variable "blue_dashboard_tg" {
    type     = string 
    description = "alb dashboard live blue tg aws reference"
}


# iam execution role variable
variable "ecs_pull" {
  type        = string
  description = "IAM role for pulling images from ECR"
}

# iam worker task role
variable "worker_task_role" {
  type        = string 
  description = "Iam task role for worker" 
}

# ecs log variable
variable "ecs_logs" {
  type        = string
  description = "ecs logs for cloudwatch"
}

variable "environment" {
    description = "environment phase " 
    type        =  string 
}