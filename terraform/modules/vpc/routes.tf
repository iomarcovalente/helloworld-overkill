# resource "aws_route_table" "private" {
#   count = length(var.subnet_cidrs.private)

#   vpc_id = aws_vpc.helloworld_overkill.id

#   # route {
#   #   cidr_block = "0.0.0.0/0"
#   #   transit_gateway_id = "tgw-0fd0668aa94cf4827"
#   # }

#   tags = {
#     env = "dev",
#     Name = "private-az${count.index + 1}"
#   }
# }

# resource "aws_route_table_association" "private" {
#   count = length(var.subnet_cidrs.private)

#   depends_on = [
#     aws_route_table.private
#   ]

#   route_table_id = element(aws_route_table.private.*.id, count.index)
#   subnet_id      = element(aws_subnet.private.*.id, count.index)
# }
