module "codedeploy_app" {
  source = "../../modules/codedeploy"
  #basic
  project = var.project
  env     = var.env

  #codedeploy-app
  codedeploy_app = {
    name             = "app"
    compute_platform = "ECS"
  }
  #codedeploy-deployment-group
  codedeploy_deployment_groups = [
    {
      deployment_group_name = "bluegreen"
      service_role_arn      = module.iam_role_codedeploy.iam_role_arn
      ecs_service = {
        cluster_name = module.ecs_cluster_backend.ecs_cluster_name
        service_name = module.ecs_app.ecs_service_name["app"]
      }
      deployment_style = {
        type = "BLUE_GREEN"
      }
      blue_green_deployment_config = {
        deployment_ready_option = {
          action_on_timeout = "CONTINUE_DEPLOYMENT"
        }
        terminate_blue_instances_on_deployment_success = {
          action                           = "TERMINATE"
          termination_wait_time_in_minutes = 0
        }
      }
      load_balancer_info = {
        target_group_pair_info = {
          listener_arns  = module.alb.alb_listener_arn["443"]
          target_group_1 = module.alb.alb_target_group_name["app-blue"]
          target_group_2 = module.alb.alb_target_group_name["app-green"]
        }
      }
    }
  ]
}
