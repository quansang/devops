#modules/codedeploy/_variables.tf
#basic
variable "project" {
  description = "Name of project"
  type        = string
}
variable "env" {
  description = "Name of project environment"
  type        = string
}

#codedeploy
variable "codedeploy_app" {
  description = "Provides a CodeDeploy application to be used as a basis for deployments"
  default     = null
  type = object({
    name             = string
    compute_platform = string
  })
}

variable "codedeploy_app_name" {
  description = "Name of the cluster"
  default     = null
  type        = string
}

#codedeploy-deployment-group
variable "codedeploy_deployment_groups" {
  description = "Provides a CodeDeploy Deployment Group for a CodeDeploy Application"
  default     = []
  type = list(object({
    deployment_group_name = string
    service_role_arn      = string
    autoscaling_groups    = optional(list(string), null)
    ecs_service = optional(object({
      cluster_name = string
      service_name = string
    }), null)
    deployment_style = object({
      type   = string
      option = optional(string, null)
    })
    blue_green_deployment_config = optional(object({
      deployment_ready_option = object({
        action_on_timeout    = string
        wait_time_in_minutes = optional(number, null)
      })
      terminate_blue_instances_on_deployment_success = object({
        action                           = string
        termination_wait_time_in_minutes = optional(number, null)
      })
    }), null)
    load_balancer_info = optional(object({
      target_group_info = optional(string, null)
      target_group_pair_info = optional(object({
        listener_arns      = string
        test_listener_arns = optional(string, null)
        target_group_1     = string
        target_group_2     = string
      }), null)
    }), null)
    ec2_tag_filter = optional(list(object({
      key   = string
      type  = string
      value = string
    })), [])
    ec2_tag_set = optional(object({
      ec2_tag_filter = optional(list(object({
        key   = string
        type  = string
        value = string
      })), [])
    }), null)
    auto_rollback_configuration = optional(object({
      enabled = optional(bool, true)
      events  = list(string)
      }),
      {
        enabled = true
        events  = ["DEPLOYMENT_FAILURE"]
    })
    trigger_configuration = optional(object({
      events     = list(string)
      name       = string
      target_arn = string
    }), null)
    alarm_configuration = optional(object({
      enabled = optional(bool, true)
      alarms  = list(string)
    }), null)
  }))
}
