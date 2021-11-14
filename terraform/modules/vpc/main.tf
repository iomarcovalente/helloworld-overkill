
resource "aws_vpc" "helloworld_overkill" {
  cidr_block = "192.168.10.0/24"

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "helloworld-overkill"
  }
}

resource "aws_vpc_ipv4_cidr_block_association" "public" {
  cidr_block = "192.168.15.0/24"
  vpc_id     = aws_vpc.helloworld_overkill.id
}

output "subnets" {
  value = {
    "private": [
      for subnet in aws_subnet.private:
      {
        "alias": subnet.tags.Name,
        "cidr": subnet.cidr_block,
        "id": subnet.id
      }
    ],
    "public": [
      for subnet in aws_subnet.public:
      {
        "alias": subnet.tags.Name,
        "cidr": subnet.cidr_block,
        "id": subnet.id
      }
    ]
  }
}
