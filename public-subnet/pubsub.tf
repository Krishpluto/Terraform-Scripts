# execute VPC_IGW 1st and then execute this pub-sub

# 1st Public Subnet Creation 
resource "aws_subnet" "PublicSubnet1" {
  vpc_id                          = data.aws_vpc.GetVPC.id
  cidr_block                      = "10.0.0.0/18"
  availability_zone               = "ap-south-1a"
 # map_customer_owned_ip_on_launch = true

  tags = {
    Name = "PublicSubnet1"
    Type = "Public"
  }
}

# 2nd Public Subnet Creation 
resource "aws_subnet" "PublicSubnet2" {
  vpc_id                          = data.aws_vpc.GetVPC.id
  cidr_block                      = "10.0.64.0/18"
  availability_zone               = "ap-south-1b"
 # map_customer_owned_ip_on_launch = true

  tags = {
    Name = "PublicSubnet2"
    Type = "Public"
  }
}