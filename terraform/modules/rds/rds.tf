# rds cred
data "aws_secretsmanager_secret" "db_creds" {
  name = "shortener_cred"
}

data "aws_secretsmanager_secret_version" "db_creds" {
  secret_id = data.aws_secretsmanager_secret.db_creds.id
}

locals {
  db_creds = jsondecode(data.aws_secretsmanager_secret_version.db_creds.secret_string)
}

# subnet group
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "main-${var.environment}"
  subnet_ids = var.private_rds

  tags = {
    Environment = var.environment
  }
}

# rds instance config
resource "aws_db_instance" "main_rds" {
  username                = local.db_creds.username
  password                = local.db_creds.password
  identifier              = "rds-db-${var.environment}"
  engine                  = "postgres"
  engine_version          = "15.13"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  storage_type            = "gp2"
  db_name                 = "main_rds"
  db_subnet_group_name    = aws_db_subnet_group.db_subnet_group.id
  vpc_security_group_ids  = [var.rds_sg]
  publicly_accessible     = false
  deletion_protection     = false
  skip_final_snapshot     = true

  maintenance_window      = "Fri:09:00-Fri:09:30"
  backup_retention_period = 7


  tags = {
    Environment = var.environment
  }
}