resource "aws_codedeploy_deployment_group" "codedeploy_deployment_group" {
  for_each = { for value in var.codedeploy_deployment_groups : value.deployment_group_name => value }

  app_name               = var.codedeploy_app != null ? aws_codedeploy_app.codedeploy_app[0].name : var.codedeploy_app_name
  deployment_group_name  = "${var.project}-${var.env}-${each.value.deployment_group_name}-deployment-group"
  service_role_arn       = each.value.service_role_arn
  deployment_config_name = var.codedeploy_app.compute_platform == "ECS" ? "CodeDeployDefault.ECSAllAtOnce" : "CodeDeployDefault.AllAtOnce"
  autoscaling_groups     = each.value.autoscaling_groups

  dynamic "ecs_service" {
    for_each = each.value.ecs_service != null ? [1] : []
    content {
      cluster_name = each.value.ecs_service.cluster_name
      service_name = each.value.ecs_service.service_name
    }
  }

  deployment_style {
    deployment_type   = each.value.deployment_style.type
    deployment_option = each.value.deployment_style.type == "BLUE_GREEN" ? "WITH_TRAFFIC_CONTROL" : each.value.deployment_style.option
  }

  dynamic "blue_green_deployment_config" {
    for_each = each.value.blue_green_deployment_config != null ? [1] : []
    content {
      deployment_ready_option {
        action_on_timeout    = each.value.blue_green_deployment_config.deployment_ready_option.action_on_timeout
        wait_time_in_minutes = each.value.blue_green_deployment_config.deployment_ready_option.action_on_timeout == "STOP_DEPLOYMENT" ? each.value.blue_green_deployment_config.deployment_ready_option.wait_time_in_minutes : null
      }

      dynamic "green_fleet_provisioning_option" {
        for_each = var.codedeploy_app.compute_platform == "EC2" ? [1] : []
        content {
          action = "DISCOVER_EXISTING"
        }
      }

      terminate_blue_instances_on_deployment_success {
        action                           = each.value.blue_green_deployment_config.terminate_blue_instances_on_deployment_success.action
        termination_wait_time_in_minutes = each.value.blue_green_deployment_config.terminate_blue_instances_on_deployment_success.action == "TERMINATE" ? each.value.blue_green_deployment_config.terminate_blue_instances_on_deployment_success.termination_wait_time_in_minutes : null
      }
    }
  }

  dynamic "load_balancer_info" {
    for_each = each.value.load_balancer_info != null ? [1] : []
    content {
      dynamic "target_group_info" {
        for_each = each.value.load_balancer_info.target_group_info != null ? [1] : []
        content {
          name = each.value.load_balancer_info.target_group_info
        }
      }
      dynamic "target_group_pair_info" {
        for_each = each.value.load_balancer_info.target_group_pair_info != null ? [1] : []
        content {
          prod_traffic_route {
            listener_arns = [each.value.load_balancer_info.target_group_pair_info.listener_arns]
          }
          dynamic "test_traffic_route" {
            for_each = each.value.load_balancer_info.target_group_pair_info.test_listener_arns != null ? [1] : []
            content {
              listener_arns = [each.value.load_balancer_info.target_group_pair_info.test_listener_arns]
            }
          }
          target_group {
            name = each.value.load_balancer_info.target_group_pair_info.target_group_1
          }
          target_group {
            name = each.value.load_balancer_info.target_group_pair_info.target_group_2
          }
        }
      }
    }
  }

  dynamic "ec2_tag_filter" {
    for_each = each.value.ec2_tag_filter
    content {
      key   = ec2_tag_filter.value.key
      type  = ec2_tag_filter.value.type
      value = ec2_tag_filter.value.value
    }
  }

  dynamic "ec2_tag_set" {
    for_each = each.value.ec2_tag_set != null ? [1] : []
    content {
      dynamic "ec2_tag_filter" {
        for_each = each.value.ec2_tag_set.ec2_tag_filter
        content {
          key   = ec2_tag_filter.value.key
          type  = ec2_tag_filter.value.type
          value = ec2_tag_filter.value.value
        }
      }
    }
  }

  auto_rollback_configuration {
    enabled = each.value.auto_rollback_configuration.enabled
    events  = each.value.auto_rollback_configuration.events
  }

  dynamic "alarm_configuration" {
    for_each = each.value.alarm_configuration != null ? [1] : []
    content {
      enabled = each.value.alarm_configuration.enabled
      alarms  = each.value.alarm_configuration.alarms
    }
  }

  dynamic "trigger_configuration" {
    for_each = each.value.trigger_configuration != null ? [1] : []
    content {
      trigger_events     = each.value.trigger_configuration.events
      trigger_name       = "${var.project}-${var.env}-${each.value.trigger_configuration.name}-trigger"
      trigger_target_arn = each.value.trigger_configuration.target_arn
    }
  }

  lifecycle {
    ignore_changes = [autoscaling_groups]
  }
}
