variable "environment" {
  type = string
}

variable "codedeploy_role_arn"{
    type = string 
    description = " iam role variable enable code deploy to run"
}

variable "cluster_name" {
    type = string 
    description = " ecs cluster umami" 
}

variable "service_name_api" {
    type = string
   
}

variable "service_name_dashboard" {
    type = string
   
}


variable "alb_listener" {
    type = list(string)
    description = "alb listener for prod traffic route" 
}



variable "blue_api_codedeploy" {
    type = string 
    description = " target group variable of blue deployment target group" 
}


variable "green_api_tg" {
    type = string 
    description = " target group variable of green deployment target group" 
}


variable "blue_codedeploy_dash" {
    type = string 
    description = " target group variable of blue deployment target group" 
}


variable "green_dashboard_tg" {
    type = string 
    description = " target group variable of green deployment target group" 
}

