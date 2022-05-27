# Internet gateway for the public subnets
resource "aws_internet_gateway" "myInternetGateway" {
  vpc_id = aws_vpc.MyVpc.id
  tags = {
    Name = "myInternetGateway"
  }
}

# Elastic IP for NAT gateway
resource "aws_eip" "nat" {
  vpc   = true
  count = var.env == "Prod" ? 1 : 0
}

# NAT Gateway
resource "aws_nat_gateway" "nat-gw" {
  count         = var.env == "Prod" ? 1 : 0
  allocation_id = element(aws_eip.nat.*.id, count.index)
  subnet_id     = element(aws_subnet.private_subnet.*.id, count.index)
  depends_on    = [aws_internet_gateway.myInternetGateway]
}