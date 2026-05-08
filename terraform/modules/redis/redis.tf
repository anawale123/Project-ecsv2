resource "aws_elasticache_subnet_group" "redis" {
  name       = "redis-subnet-group-${var.environment}"
  subnet_ids = var.private_redis
  tags = { 
    Name = "redis_subnet_group" 
  }
}

resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "shortener-redis-${var.environment}"
  engine               = "redis"
  engine_version       = "7.0"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1
  port                 = 6379
  subnet_group_name    = aws_elasticache_subnet_group.redis.name
  security_group_ids   = [var.redis_sg]
  tags = {
    Name = "redis shortener" 
  }
}