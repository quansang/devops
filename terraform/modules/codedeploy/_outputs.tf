#modules/codedeploy/_outputs.tf
output "codedeploy_app_name" {
  description = "The application's name."
  value       = (var.codedeploy_app != null && var.codedeploy_app_name == null) ? aws_codedeploy_app.codedeploy_app[0].name : var.codedeploy_app_name
}
output "codedeploy_deployment_group_name" {
  description = "The name of the CodeDeploy deployment group."
  value       = (var.codedeploy_app != null && var.codedeploy_app_name == null) ? { for key, value in aws_codedeploy_deployment_group.codedeploy_deployment_group : key => value.deployment_group_name } : null
}
