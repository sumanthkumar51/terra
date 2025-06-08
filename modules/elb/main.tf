# Security Group
resource "aws_security_group" "allow_all_sg" {
  name        = "web_sg"
  description = "Allow HTTP, HTTPS, ICMP, and SSH traffic for web servers"
  vpc_id      = var.vpc_id

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
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

# Load Balancer
resource "aws_elb" "my_elb" {
  name               = "example-elb"
  subnets            = var.subnet_ids
  security_groups    = [aws_security_group.allow_all_sg.id]

  listener {
    instance_port     = 80
    instance_protocol = "HTTP"
    lb_port           = 80
    lb_protocol       = "HTTP"
  }

  health_check {
    target              = "HTTP:80/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  cross_zone_load_balancing = true
  idle_timeout              = 400
  connection_draining       = true
  connection_draining_timeout = 400

  tags = {
    Name        = "example-elb"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
} 