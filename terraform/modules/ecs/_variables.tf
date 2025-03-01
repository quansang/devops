#modules/ecs/_variables.tf
#basic
variable "project" {
  description = "Name of project"
  type        = string
}
variable "env" {
  description = "Name of project environment"
  type        = string
}

#ecs
variable "ecs_cluster_name" {
  description = "Name for creating the ecs cluster"
  default     = null
  type        = string
}
variable "ecs_cluster_id" {
  description = "ID of the existing ecs cluster"
  default     = null
  type        = string
}

#ecs-service
variable "ecs_services" {
  description = "All configurations to Provides a ECS Service resource for use with ECS resources"
  default     = []
  type = list(object({
    name                               = string
    desired_count                      = number
    security_groups_id                 = list(string)
    subnets_id                         = list(string)
    platform_version                   = optional(string, "1.4.0")
    deployment_minimum_healthy_percent = optional(number, 100)
    deployment_maximum_percent         = optional(number, 200)
    deployment_controller              = optional(string, "ECS")
    load_balancer = optional(list(object({
      target_group_arn = string
      container_name   = string
      container_port   = number
    })), [])
    health_check_grace_period_seconds = optional(number, 120)
  }))
}

#ecs-task-definition
variable "ecs_task_definition" {
  description = "All configurations to Provides a ECS Task Definitions resource for use with ECS resources"
  default     = null
  type = object({
    execution_role_arn = string
    task_definitions = optional(list(object({
      name                  = string
      total_memory          = number
      total_cpu             = number
      task_role_arn         = string
      container_definitions = string
    })), [])
  })
}
