module "ecs_app" {
  source = "../../modules/ecs"
  #basic
  project = var.project
  env     = var.env

  #ecs-service
  ecs_cluster_id = module.ecs_cluster_backend.ecs_cluster_id
  ecs_services = [
    {
      name                  = "app"
      desired_count         = var.ecs.app.desired_count
      security_groups_id    = [module.security_group_ecs_task_app.security_group_id]
      subnets_id            = module.vpc.subnet_private_id
      deployment_controller = "CODE_DEPLOY"
      load_balancer = [
        {
          target_group_arn = module.alb.alb_target_group_arn["app-blue"]
          container_name   = "${var.project}-${var.env}-app-container"
          container_port   = var.ecs.app.container_port
        }
      ]
    }
  ]
  #ecs-task-definition
  ecs_task_definition = {
    execution_role_arn = module.iam_role_ecs_task_execution.iam_role_arn
    task_definitions = [
      {
        name          = "app"
        total_memory  = var.ecs.app.total_memory
        total_cpu     = var.ecs.app.total_cpu
        task_role_arn = module.iam_role_ecs_task_app.iam_role_arn
        container_definitions = templatefile("../../../dependencies/templates/ecs/taskdef-app.json",
          {
            name           = "${var.project}-${var.env}-app-container"
            image          = module.ecr_app.ecr_repository_url
            tag            = "latest"
            containerPort  = var.ecs.app.container_port
            hostPort       = var.ecs.app.host_port
            awslogs_group  = module.cloudwatch_log_group_ecs_task_app.cloudwatch_log_group_name
            awslogs_region = var.region
          }
        )
      }
    ]
  }
}
