# Vpc resource
resource "aws_vpc" "MyVpc" {
  cidr_block           = "10.20.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "MyVpc"
  }
}