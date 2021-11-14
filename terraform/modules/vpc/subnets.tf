# Private subnets
resource "aws_subnet" "private" {
  availability_zone_id = element(var.az_ids, count.index)
  cidr_block = element(var.subnet_cidrs.private, count.index)
  count = length(var.subnet_cidrs.private)

  tags = {
    env = "dev"
    Name = "private-az${count.index + 1}"
  }

  vpc_id = aws_vpc.main.id
}

# Public subnets
resource "aws_subnet" "public" {
  availability_zone_id = element(var.az_ids, count.index)
  cidr_block = element(var.subnet_cidrs.public, count.index)
  count = length(var.subnet_cidrs.public)

  depends_on = [
    aws_vpc_ipv4_cidr_block_association.public
  ]

  tags = {
    env = "dev"
    Name = "public-az${count.index + 1}"
  }

  vpc_id = aws_vpc.main.id
}
