resource "aws_security_group" "alb_sg" {
  name   = "alb-sg-${var.environment}"
  vpc_id = aws_vpc.vpc_app.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "alb_sg"
    Environment = var.environment
  }
}

resource "aws_security_group" "dashboard_sg" {
  name   = "dashboard_sg-${var.environment}"
  vpc_id = aws_vpc.vpc_app.id

  ingress {
    from_port       = 8081
    to_port         = 8081
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  tags = {
    Name        = "dashboard_sg"
    Environment = var.environment
  }
}

resource "aws_security_group" "api_sg" {
  name   = "api_sg-${var.environment}"
  vpc_id = aws_vpc.vpc_app.id

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  tags = {
    Name        = "api_sg"
    Environment = var.environment
  }
}

resource "aws_security_group" "worker_sg" {
  name   = "worker_sg-${var.environment}"
  vpc_id = aws_vpc.vpc_app.id

  tags = {
    Name        = "worker_sg"
    Environment = var.environment
  }
}

resource "aws_security_group" "rds_sg" {
  name   = "rds_sg-${var.environment}"
  vpc_id = aws_vpc.vpc_app.id

  tags = {
    Name        = "rds_sg"
    Environment = var.environment
  }
}

resource "aws_security_group" "redis_sg" {
  name   = "redis_sg-${var.environment}"
  vpc_id = aws_vpc.vpc_app.id

  tags = {
    Name        = "redis_sg"
    Environment = var.environment
  }
}

resource "aws_security_group" "vpc_endpoints_sg" {
  name   = "vpc_endpoint_sg-${var.environment}"
  vpc_id = aws_vpc.vpc_app.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "vpc_endpoint_sg"
    Environment = var.environment
  }
}

resource "aws_security_group_rule" "dashboard_to_rds" {
  type                     = "egress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.dashboard_sg.id
  source_security_group_id = aws_security_group.rds_sg.id
}

resource "aws_security_group_rule" "dashboard_to_vpc_endpoints" {
  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.dashboard_sg.id
  source_security_group_id = aws_security_group.vpc_endpoints_sg.id
}

resource "aws_security_group_rule" "dashboard_to_internet_443" {
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.dashboard_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "api_to_rds" {
  type                     = "egress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.api_sg.id
  source_security_group_id = aws_security_group.rds_sg.id
}

resource "aws_security_group_rule" "api_to_redis" {
  type                     = "egress"
  from_port                = 6379
  to_port                  = 6379
  protocol                 = "tcp"
  security_group_id        = aws_security_group.api_sg.id
  source_security_group_id = aws_security_group.redis_sg.id
}

resource "aws_security_group_rule" "api_to_vpc_endpoints" {
  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.api_sg.id
  source_security_group_id = aws_security_group.vpc_endpoints_sg.id
}

resource "aws_security_group_rule" "api_to_internet_443" {
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.api_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "worker_to_rds" {
  type                     = "egress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.worker_sg.id
  source_security_group_id = aws_security_group.rds_sg.id
}

resource "aws_security_group_rule" "worker_to_redis" {
  type                     = "egress"
  from_port                = 6379
  to_port                  = 6379
  protocol                 = "tcp"
  security_group_id        = aws_security_group.worker_sg.id
  source_security_group_id = aws_security_group.redis_sg.id
}

resource "aws_security_group_rule" "worker_to_vpc_endpoints" {
  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.worker_sg.id
  source_security_group_id = aws_security_group.vpc_endpoints_sg.id
}

resource "aws_security_group_rule" "worker_to_internet_443" {
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.worker_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "rds_from_api" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.rds_sg.id
  source_security_group_id = aws_security_group.api_sg.id
}

resource "aws_security_group_rule" "rds_from_worker" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.rds_sg.id
  source_security_group_id = aws_security_group.worker_sg.id
}

resource "aws_security_group_rule" "rds_from_dashboard" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.rds_sg.id
  source_security_group_id = aws_security_group.dashboard_sg.id
}

resource "aws_security_group_rule" "redis_from_api" {
  type                     = "ingress"
  from_port                = 6379
  to_port                  = 6379
  protocol                 = "tcp"
  security_group_id        = aws_security_group.redis_sg.id
  source_security_group_id = aws_security_group.api_sg.id
}

resource "aws_security_group_rule" "redis_from_worker" {
  type                     = "ingress"
  from_port                = 6379
  to_port                  = 6379
  protocol                 = "tcp"
  security_group_id        = aws_security_group.redis_sg.id
  source_security_group_id = aws_security_group.worker_sg.id
}
