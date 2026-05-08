resource "aws_subnet" "alb_subnet" {
  vpc_id            = aws_vpc.vpc_app.id
  cidr_block        = var.alb_cidr
  availability_zone = "eu-west-2c"

  tags = {
    Name        = "alb-subnet-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_subnet" "alb_subnet_b" {
  vpc_id            = aws_vpc.vpc_app.id
  cidr_block        = var.alb_cidr_b
  availability_zone = "eu-west-2b"

  tags = {
    Name        = "alb-subnet-b-${var.environment}"
    Environment = var.environment
  }
}
