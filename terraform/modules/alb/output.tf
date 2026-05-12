
output "alb_arn" {
  description = " alb arn reference output variable"
  value       = aws_lb.alb_main.arn
}


output "blue_api_tg" {
  description = "  Main app target group"
  value       = aws_lb_target_group.blue_api_tg.arn
}

output "blue_api_codedeploy" {
  description = "  Main app target group"
  value       = aws_lb_target_group.blue_api_tg.name
}

output "green_api_tg" {
  description = " green target group for code deploy" 
  value       =  aws_lb_target_group.green_api_tg.name
}

output "alb_arn_suffix" {
  value = aws_lb.alb_main.arn_suffix
}
output "alb_listener" {
  value = [aws_lb_listener.https.arn]
}
output "blue_dashboard_tg" {
  description = "  Main app target group"
  value       = aws_lb_target_group.blue_dashboard_tg.arn
}

output "blue_codedeploy_dash" {
  description = "  Main app target group"
  value       = aws_lb_target_group.blue_dashboard_tg.name
}


output "green_dashboard_tg" {
  description = " green target group for code deploy" 
  value       =  aws_lb_target_group.green_dashboard_tg.name
}


output "api_tg_arn_suffix" {
  description = "api tg arn suffix"
  value = aws_lb_target_group.blue_api_tg.arn_suffix
}

output "dashboard_tg_arn_suffix" {
  description = "blue tg arn suffix"
  value = aws_lb_target_group.blue_dashboard_tg.arn_suffix
}





