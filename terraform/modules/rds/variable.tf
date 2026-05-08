# vpc variable 
variable "vpc_id" {
  description = "vpc id variable"
  type        = string
}


# private subnet id variable rds
variable "private_rds" {
  description = "List of private subnet ids for rds "
  type        = list(string)
}

# security group rds
variable "rds_sg" {
  description = " rds security group"
  type        = string
}

# environment variable
variable "environment" {
  type = string
}