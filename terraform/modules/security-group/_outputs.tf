#modules/security-group/_outputs.tf
output "security_group_id" {
  value       = var.security_group != null ? aws_security_group.security_group[0].id : null
  description = "The ID of the security group"
}
output "security_group_arn" {
  value       = var.security_group != null ? aws_security_group.security_group[0].arn : null
  description = "The ARN of the security group"
}
output "security_group_name" {
  value       = var.security_group != null ? aws_security_group.security_group[0].name : null
  description = "The name of the security group"
}
