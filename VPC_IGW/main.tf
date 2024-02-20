# VPC Creation
resource "aws_vpc" "CustomVPC" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "CustomVPC"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.CustomVPC.id
  tags = {
    Name = "IGW"
  }
}

# Default Route Table
resource "aws_default_route_table" "associate_vpc" {
  default_route_table_id = aws_vpc.CustomVPC.main_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }
  tags = {
    Name = "associate_vpc"
  }
}