# VPC ID VARIABLE
variable "vpc_id" {
  description = "main aws_vpc"
  type        = string
}


# ALB SG VARIABLE
variable "alb_sg" {
  description = "alb security group"
  type        = string
}

# PUBLIC SUBNET VARIABLE
variable "public_subnets" {
  description = "List of public subnet IDs for the ALB"
  type        = list(string)
}

variable "environment" {
    description = "environment phase " 
    type        =  string 
}

variable "s3_access_logs_alb" {
  description = "s3 access log alb" 
  type        = string
}