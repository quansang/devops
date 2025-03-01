#modules/codestar/_outputs.tf
output "codestar_connection_id" {
  description = "The codestar connection ARN."
  value       = aws_codestarconnections_connection.codestar_connection.id
}
output "codestar_connection_arn" {
  description = "The codestar connection ARN."
  value       = aws_codestarconnections_connection.codestar_connection.arn
}
