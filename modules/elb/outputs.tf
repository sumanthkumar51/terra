output "elb_dns_name" {
  description = "The DNS name of the load balancer"
  value       = aws_elb.my_elb.dns_name
}

output "security_group_id" {
  description = "The ID of the security group"
  value       = aws_security_group.allow_all_sg.id
} 