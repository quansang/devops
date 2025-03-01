module "ecr_app" {
  source = "../../modules/ecr"
  #basic
  project = var.project
  env     = var.env

  #ecr
  ecr = {
    name         = "app"
    scan_on_push = true
  }
}
