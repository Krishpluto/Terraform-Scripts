#-------AWS Security Group for Auto Scaling Group (ASG) for EC2 instance----------------
resource "aws_security_group" "asg_sg" {
  name        = "ASG_Allow_Traffic"
  description = "Allow all inbound traffic for ASG"
  vpc_id      = data.aws_vpc.GetVPC.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8
    to_port     = 8
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

##### Egress is set to "traffic should flow to all"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-asg-security-group"
  }
}

#--------AWS Target Group for ASG-----------
resource "aws_lb_target_group" "ASGTG" {
  name = "ASGTG"
  port = 80
  protocol = "HTTP"
  vpc_id = data.aws_vpc.GetVPC.id
  target_type = "instance"
}

#---------Launch Configuration-------------
resource "aws_launch_configuration" "launch_config_dev" {
  name_prefix = "webtier_dev"
  image_id = "ami-0e670eb768a5fc3d4" 
  instance_type = var.instance_type
  #key_name = var.aws_key_pair
  security_groups = ["${aws_security_group.asg_sg.id}"]
  associate_public_ip_address = true
  user_data = <<EOF
    #! /bin/bash
    sudo su
    sudo yum update
    sudo yum install -y httpd
    sudo chkconfig httpd start
    echo "<h1>Deployed EC2 Using ASG</h1>" | sudo tee /var/www/html/index.html
    EOF
  lifecycle {
    create_before_destroy = true
  }  
}

#-------Create AutoScaling Group----------
resource "aws_autoscaling_group" "autoscaling_group_dev" {
  launch_configuration = aws_launch_configuration.launch_config_dev.id
  min_size = var.autoscaling_group_min_size
  max_size = var.autoscaling_group_max_size
  target_group_arns = ["${aws_lb_target_group.ASGTG.arn}"]
  vpc_zone_identifier = data.aws_subnets.GetSubnet.ids

  tag {
    key = "Name"
    value = "autoscaling-group-dev"
    propagate_at_launch = true
  }
}