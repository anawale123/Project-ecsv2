# vpc output variable  
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.vpc_app.id
}

# private subnet output variable
output "private_subnet" {
  description = " private subnets"
  value       = aws_subnet.private_subnet.id
}

# public subnets
output "public_subnets" {
  description = "List of public subnet ids for alb"
  value       = [aws_subnet.alb_subnet.id, aws_subnet.alb_subnet_b.id]
}

# private rds subnet
output "private_rds" {
  description = "rds subnets"
  value       = [aws_subnet.private_rds.id, aws_subnet.private_rds_b.id]
}

# private redis cache 
output "private_redis" {
  description = "redis subnets"
  value       = [aws_subnet.private_redis.id, aws_subnet.private_redis_b.id]
}

# alb security group
output "alb_sg" {
  description = "alb sg"
  value       = aws_security_group.alb_sg.id
}

# api security group 
output "api_sg" {
  description = "api sg"
  value       = aws_security_group.api_sg.id
}

# dashboard security group
output "dashboard_sg" {
  description = "dashboard sg"
  value       = aws_security_group.dashboard_sg.id
}

# worker security group
output "worker_sg" {
  description = "worker sg"
  value       = aws_security_group.worker_sg.id
}

# rds security group 
output "rds_sg" {
  description = "rds sg"
  value       = aws_security_group.rds_sg.id
}

# redis security group 
output "redis_sg" {
  description = "redis sg"
  value       = aws_security_group.redis_sg.id
}