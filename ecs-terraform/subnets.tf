# Subnet (public)
resource "aws_subnet" "public_subnet" {
  count                   = var.env == "Blue" ? length(data.aws_availability_zones.available.names) : 0
  vpc_id                  = aws_vpc.MyVpc.id
  cidr_block              = "10.20.${10 + count.index}.0/24"
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "PublicSubnet-${count.index}"
  }
}


# Subnet (private)
resource "aws_subnet" "private_subnet" {
  count                   = var.env == "Prod" ? length(data.aws_availability_zones.available.names) : 0
  vpc_id                  = aws_vpc.MyVpc.id
  cidr_block              = "10.20.${20 + count.index}.0/24"
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "PrivateSubnet-${count.index}"
  }
}
