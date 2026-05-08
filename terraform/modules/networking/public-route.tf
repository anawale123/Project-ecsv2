resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc_app.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name        = "public-alb-route-table-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_route_table_association" "public_assoc_a" {
  subnet_id      = aws_subnet.alb_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_assoc_b" {
  subnet_id      = aws_subnet.alb_subnet_b.id
  route_table_id = aws_route_table.public_rt.id
}
