output "asg_name" {
  description = "The name of the Auto Scaling Group"
  value       = aws_autoscaling_group.my_asg.name
}

output "launch_template_id" {
  description = "The ID of the launch template"
  value       = aws_launch_template.example.id
} 