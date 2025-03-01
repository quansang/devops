module "security_group_ecs_task_app" {
  source = "../../modules/security-group"
  #basic
  project = var.project
  env     = var.env

  #security-group
  security_group = {
    name   = "ecs-task-app"
    vpc_id = module.vpc.vpc_id
    ingress_rules = [
      {
        from_port       = var.ecs.app.container_port
        to_port         = var.ecs.app.container_port
        protocol        = "tcp"
        description     = "Allow for ECS app port from ALB"
        security_groups = [module.security_group_alb.security_group_id]
      }
    ]
  }
}
