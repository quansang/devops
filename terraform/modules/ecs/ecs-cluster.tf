###################
# ECS Cluster
###################
resource "aws_ecs_cluster" "ecs_cluster" {
  count = var.ecs_cluster_name != null ? 1 : 0

  name = "${var.project}-${var.env}-${var.ecs_cluster_name}-ecs-cluster"

  tags = {
    Name = "${var.project}-${var.env}-${var.ecs_cluster_name}-ecs-cluster"
  }
}
