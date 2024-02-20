variable "AWS_REGION" {
  default = "ap-south-1"
}

#----------Fetch VPC ID------------
data "aws_vpc" "GetVPC" {
  filter {
    name = "tag:Name"
    values = ["CustomVPC"]
  } 
}

#--------Variables for autoscaling--------
variable "instance_type" {
  type = string
  default = "t2.micro"
}
variable "autoscaling_group_min_size" {
  type = number
  default = 2
}
variable "autoscaling_group_max_size" {
  type = number
  default = 3
}

#--------Fetch Public Subnets List-------
data "aws_subnets" "GetSubnet" {
  filter {
    name = "vpc-id"
    values = [data.aws_vpc.GetVPC.id]
  }
  filter {
    name = "tag:Type"
    values = ["Public"]
  }
}