module "networking" {
  source = "../../../modules/networking"
  environment   = var.environment

}

module "iam" {
  source = "../../../modules/iam"
   environment   = var.environment
}



module "sqs" {
  source = "../../../modules/sqs"
   environment   = var.environment
  
}


module "alb" {
  source = "../../../modules/alb"

  vpc_id         = module.networking.vpc_id
  public_subnets = module.networking.public_subnets
  alb_sg         = module.networking.alb_sg
  environment   = var.environment
}



module "rds" {
  source = "../../../modules/rds"

  vpc_id      = module.networking.vpc_id
  private_rds = module.networking.private_rds
  rds_sg      = module.networking.rds_sg
  environment   = var.environment
}

module "redis" {
  source = "../../../modules/redis"

  vpc_id      = module.networking.vpc_id
  private_redis = module.networking.private_redis
  redis_sg      = module.networking.redis_sg
  environment   = var.environment
}

variable "environment" {
  type = string
  default = "dev"
}