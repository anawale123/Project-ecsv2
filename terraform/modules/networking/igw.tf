resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_app.id

  tags = {
    Name        = "main-${var.environment}"
    Environment = var.environment
  }
}
