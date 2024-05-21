output "webserver_securitygroup_id" {
  description = "ID of the VPC"
  value       = aws_security_group.web_sg.id
}
