#modules/ecs/_outputs.tf
#ecs-cluster
output "ecs_cluster_id" {
  description = "ARN that identifies the cluster"
  value       = var.ecs_cluster_name != null ? aws_ecs_cluster.ecs_cluster[0].id : var.ecs_cluster_id
}
output "ecs_cluster_arn" {
  description = "ARN that identifies the cluster"
  value       = var.ecs_cluster_name != null ? aws_ecs_cluster.ecs_cluster[0].arn : null
}
output "ecs_cluster_name" {
  description = "Name of the cluster"
  value       = var.ecs_cluster_name != null ? aws_ecs_cluster.ecs_cluster[0].name : null
}

#ecs-service
output "ecs_service_name" {
  description = "Name of the service"
  value       = length(var.ecs_services) > 0 ? { for key, value in aws_ecs_service.ecs_service : key => value.name } : {}
}
output "ecs_service_arn" {
  description = "ARN that identifies the service"
  value       = length(var.ecs_services) > 0 ? values(aws_ecs_service.ecs_service)[*].id : []
}

#ecs-task-definition
output "ecs_task_definition_arn" {
  description = "ARN of the Task Definition"
  value       = var.ecs_task_definition != null ? { for key, value in aws_ecs_task_definition.ecs_task_definition : key => value.arn } : null
}
output "ecs_task_definition_family" {
  description = "Family of the Task Definition"
  value       = var.ecs_task_definition != null ? { for key, value in aws_ecs_task_definition.ecs_task_definition : key => value.family } : null
}
