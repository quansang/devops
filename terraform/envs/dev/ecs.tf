module "ecs_cluster_backend" {
  source = "../../modules/ecs"
  #basic
  project = var.project
  env     = var.env

  #ecs-cluster
  ecs_cluster_name = "backend"
}
