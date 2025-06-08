# This Terraform configuration creates a VPC with two public subnets in the us-east-1 region.
# It also sets up an internet gateway, a route table, and security groups to allow HTTP, HTTPS, ICMP, and SSH traffic.
# provider
# vpc 
# subnets 
#  internet gateway

  


provider "aws" {
  region = "us-east-1"
}



# VPC
resource "aws_vpc" "new_vpc" {
  cidr_block           = "20.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "terraform_vpc"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

# Subnets
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.new_vpc.id
  cidr_block             = "20.0.1.0/24"
  availability_zone      = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name        = "subnet-one"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

resource "aws_subnet" "second_subnet" {
  vpc_id                  = aws_vpc.new_vpc.id
  cidr_block             = "20.0.2.0/24"
  availability_zone      = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name        = "subnet-two"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.new_vpc.id

  tags = {
    Name        = "terraform_igw"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

# Route Table
resource "aws_route_table" "rtable" {
  vpc_id = aws_vpc.new_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name        = "terraform_rtable"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

# Route Table Associations
resource "aws_route_table_association" "subnet_one_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.rtable.id
}

resource "aws_route_table_association" "subnet_two_association" {
  subnet_id      = aws_subnet.second_subnet.id
  route_table_id = aws_route_table.rtable.id
}

# Security Group
resource "aws_security_group" "allow_all_sg" {
  name        = "web_sg"
  description = "Allow HTTP, HTTPS, ICMP, and SSH traffic for web servers"
  vpc_id      = aws_vpc.new_vpc.id

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ICMP from anywhere"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "allow_web_sg"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

# Launch Template
resource "aws_launch_template" "example" {
  name_prefix   = "example_template"
  image_id      = "ami-02457590d33d576c3"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.allow_all_sg.id]


  user_data = base64encode(<<-EOF
#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
echo "<h1>Hello from $(hostname -f)</h1>" > /var/www/html/index.html
EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "example_instance"
      Environment = "production"
      ManagedBy   = "terraform"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Load Balancer
resource "aws_elb" "my_elb" {
  name               = "example-elb"
  subnets            = [aws_subnet.public_subnet.id, aws_subnet.second_subnet.id]
  security_groups    = [aws_security_group.allow_all_sg.id]


  listener {
    instance_port     = 80
    instance_protocol = "HTTP"
    lb_port           = 80
    lb_protocol       = "HTTP"
  }


  tags = {
    Name        = "example-elb"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}


# Auto Scaling Group - not working 
/* resource "aws_autoscaling_group" "my_asg" {
  launch_configuration = aws_launch_template.example.id
    min_size             = 1
    max_size             = 3
    desired_capacity     = 2
    health_check_type   = "EC2"
    load_balancers       = [aws_elb.my_elb.id]
    vpc_zone_identifier = [aws_subnet.public_subnet.id, aws_subnet.second_subnet.id]
} */
resource "aws_autoscaling_group" "my_asg" {
  launch_template {
    id      = aws_launch_template.example.id
    version = "$Latest"  # Ensures the latest version of the launch template is used
  }
  min_size             = 1
  max_size             = 3
  desired_capacity     = 2
  health_check_type    = "ELB"  # Recommended for load-balanced instances
  load_balancers       = [aws_elb.my_elb.id]
  vpc_zone_identifier  = [aws_subnet.public_subnet.id, aws_subnet.second_subnet.id]
}