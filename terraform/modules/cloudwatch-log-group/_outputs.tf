#modules/cloudwatch-log-group/_outputs.tf
output "cloudwatch_log_group_arn" {
  description = "Amazon Resource Name (ARN) identifying your CloudWatch log group"
  value       = aws_cloudwatch_log_group.cloudwatch_log_group.arn
}
output "cloudwatch_log_group_name" {
  description = "Name of CloudWatch log group"
  value       = aws_cloudwatch_log_group.cloudwatch_log_group.name
}
