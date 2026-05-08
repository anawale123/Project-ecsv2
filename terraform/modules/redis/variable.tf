# vpc variable 
variable "vpc_id" {
  description = "vpc id variable"
  type        = string
}


# security group rds
variable "redis_sg" {
  description = " rds security group"
  type        = string
}



# private subnet id variable redis
variable "private_redis" {
  description = "List of private subnet ids for redis"
  type        = list(string)
}

# environment variable
variable "environment" {
  type = string
}