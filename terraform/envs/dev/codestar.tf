module "codestar_connection" {
  source = "../../modules/codestar"
  #basic
  env     = var.env
  project = var.project
}
