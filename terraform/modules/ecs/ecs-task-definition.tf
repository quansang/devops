######################
# ECS Task Definition
######################
resource "aws_ecs_task_definition" "ecs_task_definition" {
  for_each = var.ecs_task_definition != null ? { for value in var.ecs_task_definition.task_definitions : value.name => value } : {}

  family                   = "${var.project}-${var.env}-${each.value.name}-task-definition"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = var.ecs_task_definition.execution_role_arn
  memory                   = each.value.total_memory
  cpu                      = each.value.total_cpu
  task_role_arn            = each.value.task_role_arn
  container_definitions    = each.value.container_definitions #using templatefile() to render the container_definitions

  tags = {
    Name = "${var.project}-${var.env}-${each.value.name}-task-definition"
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = all
  }
}
