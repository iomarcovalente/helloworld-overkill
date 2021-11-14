resource "aws_route_table" "public" {
  count = length(var.subnet_cidrs.public)

  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    env = "dev",
    Name = "public-az${count.index + 1}"
  }
}

resource "aws_route_table_association" "public" {
  count = length(var.subnet_cidrs.public)

  depends_on = [
    aws_route_table.public
  ]

  route_table_id = element(aws_route_table.public.*.id, count.index)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
}
