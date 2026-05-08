resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc_app.id

  tags = {
    Name        = "private-route-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}
