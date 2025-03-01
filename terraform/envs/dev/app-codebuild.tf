module "codebuild_app" {
  source = "../../modules/codebuild"
  #basic
  project = var.project
  env     = var.env

  #codebuild
  codebuild = {
    name         = "app"
    service_role = module.iam_role_codebuild.iam_role_arn
    source       = { buildspec = "./ops/buildspec.yml" }
    environment = {
      compute_type = "BUILD_GENERAL1_SMALL"
      image        = "aws/codebuild/standard:7.0-23.07.28"
      variables = [
        {
          name  = "AWS_REGION"
          value = var.region
        },
        {
          name  = "AWS_ACCOUNT_ID"
          value = var.account_id
        },
        {
          name  = "AWS_REPOSITORY_NAME"
          value = module.ecr_app.ecr_name
        },
        {
          name  = "TASKDEF_TYPE"
          value = "app"
        },
        {
          name  = "AWS_ECS_TASK_FAMILY"
          value = module.ecs_app.ecs_task_definition_family["app"]
        },
        {
          name  = "AWS_EXECUTION_ROLE_ARN"
          value = module.iam_role_ecs_task_execution.iam_role_arn
        },
        {
          name  = "AWS_TASK_ROLE_ARN"
          value = module.iam_role_ecs_task_app.iam_role_arn
        },
        {
          name  = "AWS_LOGS_GROUP"
          value = module.cloudwatch_log_group_ecs_task_app.cloudwatch_log_group_name
        },
        {
          name  = "ENV"
          value = var.env
        },
        {
          name  = "CONTAINER_NAME"
          value = "${var.project}-${var.env}-app-container"
        },
        {
          name  = "CONTAINER_PORT"
          value = var.ecs.app.container_port
        },
        {
          name  = "HOST_PORT"
          value = var.ecs.app.host_port
        },
        {
          name  = "TASK_MEMORY"
          value = var.ecs.app.task_memory
        },
        {
          name  = "TASK_CPU"
          value = var.ecs.app.task_cpu
        }
      ]
    }
  }
}
