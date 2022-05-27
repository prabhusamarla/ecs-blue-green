# Routing table for public subnets
resource "aws_route_table" "rtblPublic" {
  count  = var.env == "Blue" ? 1 : 0
  vpc_id = aws_vpc.MyVpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myInternetGateway.id
  }

  tags = {
    Name = "rtblPublic"
  }
}

resource "aws_route_table_association" "route" {
  count          = var.env == "Blue" ? length(data.aws_availability_zones.available.names) : 0
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = element(aws_route_table.rtblPublic.*.id, count.index)
}





# Routing table for private subnets
resource "aws_route_table" "rtblPrivate" {
  count  = var.env == "Prod" ? 1 : 0
  vpc_id = aws_vpc.MyVpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw[count.index].id
  }

  tags = {
    Name = "rtblPrivate"
  }
}

resource "aws_route_table_association" "private_route" {
  count          = var.env == "Prod" ? length(data.aws_availability_zones.available.names) : 0
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = element(aws_route_table.rtblPrivate.*.id, count.index)
}