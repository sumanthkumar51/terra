output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.new_vpc.id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = [aws_subnet.public_subnet.id, aws_subnet.second_subnet.id]
}

output "vpc_cidr" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.new_vpc.cidr_block
} 