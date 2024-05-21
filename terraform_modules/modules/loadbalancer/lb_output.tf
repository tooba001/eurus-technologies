output "launch_template_id" {
  description = "ID of the VPC"
  value       = aws_launch_template.wordpresslaunchtemplate.id
}

output "target_group_arns" {
  description = "ID of the VPC"
  value       = [aws_lb_target_group.wptargetgroup.id]
}


