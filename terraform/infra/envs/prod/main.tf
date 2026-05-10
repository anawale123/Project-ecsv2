terraform {
  required_version = ">= 1.0"
}


module "networking" {
  source      = "../../../modules/networking"
  environment = "prod"
}

module "iam" {
  source      = "../../../modules/iam"
  environment = "prod"
}

module "cloudwatch" {
  source                 = "../../../modules/cloudwatch"
  environment            = "prod"
  cluster_name           = module.ecs.cluster_name
  alb_arn_suffix         = module.alb.alb_arn_suffix
  api_service_name       = module.ecs.api_service_name
  dashboard_service_name = module.ecs.dashboard_service_name
  worker_service_name    = module.ecs.worker_service_name
  sqs_queue_name         = module.sqs.sqs_queue_name
  dlq_queue_name         = module.sqs.dlq_queue_name
  db_identifier          = module.rds.db_identifier
}

module "sqs" {
  source      = "../../../modules/sqs"
  environment = "prod"
}



module "alb" {
  source         = "../../../modules/alb"
  environment    = "prod"
  vpc_id         = module.networking.vpc_id
  public_subnets = module.networking.public_subnets
  alb_sg         = module.networking.alb_sg
  s3_access_logs_alb = module.s3.s3_access_logs_alb
}

module "ecs" {
  source            = "../../../modules/ecs"
  environment       = "prod"
  vpc_id            = module.networking.vpc_id
  alb_arn           = module.alb.alb_arn
  private_subnet    = module.networking.private_subnet
  api_sg            = module.networking.api_sg
  dashboard_sg      = module.networking.dashboard_sg
  worker_sg         = module.networking.worker_sg
  blue_dashboard_tg = module.alb.blue_dashboard_tg
  blue_api_tg       = module.alb.blue_api_tg
  ecs_pull          = module.iam.ecs_pull
  worker_task_role  = module.iam.worker_task_role
  ecs_logs          = module.cloudwatch.ecs_logs
}

module "codedeploy" {
    source            = "../../../modules/codedeploy"
    environment   = "prod"
    codedeploy_role_arn = module.iam.codedeploy_role_arn
    cluster_name        = module.ecs.cluster_name
    service_name_api    = module.ecs.api_service_name
    service_name_dashboard = module.ecs.dashboard_service_name
    alb_listener        = module.alb.alb_listener
    blue_api_tg         = module.alb.blue_api_tg
    green_api_tg        = module.alb.green_api_tg
    blue_dashboard_tg   = module.alb.blue_dashboard_tg
    green_dashboard_tg  = module.alb.green_dashboard_tg

}

module "ats" {
    source            = "../../../modules/autoscaling"
    environment   = "prod"
    cluster        = module.ecs.cluster_name 
    service        = module.ecs.api_service_name 



}

module "rds" {
  source        = "../../../modules/rds"
  environment   = "prod"
  vpc_id        = module.networking.vpc_id
  private_rds   = module.networking.private_rds
  rds_sg        = module.networking.rds_sg
}


module "s3" {
  source        = "../../../modules/s3"
  environment   = "prod"


}

module "redis" {
  source        = "../../../modules/redis"
  environment   = "prod"
  vpc_id        = module.networking.vpc_id
  private_redis = module.networking.private_redis
  redis_sg      = module.networking.redis_sg
}

module "waf" {
  source        = "../../../modules/waf"
  environment   = "prod"
  alb_arn       =  module.alb.alb_arn

}