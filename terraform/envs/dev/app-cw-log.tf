module "cloudwatch_log_group_ecs_task_app" {
  source = "../../modules/cloudwatch-log-group"
  #cloudwatch-log-group
  name              = "${var.project}-${var.env}-${var.region}-ecs-task-app"
  retention_in_days = 30
}
