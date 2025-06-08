# VPC
resource "aws_vpc" "new_vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "terraform_vpc"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

# Subnets
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.new_vpc.id
  cidr_block             = var.public_subnet_cidr
  availability_zone      = var.az1
  map_public_ip_on_launch = true

  tags = {
    Name        = "subnet-one"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

resource "aws_subnet" "second_subnet" {
  vpc_id                  = aws_vpc.new_vpc.id
  cidr_block             = var.public_subnet_cidr2
  availability_zone      = var.az2
  map_public_ip_on_launch = true

  tags = {
    Name        = "subnet-two"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.new_vpc.id

  tags = {
    Name        = "terraform_igw"
    Environment = var.environment
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
    Environment = var.environment
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