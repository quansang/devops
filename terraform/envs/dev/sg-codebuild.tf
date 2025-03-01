module "security_group_codebuild_app" {
  source = "../../modules/security-group"
  #basic
  project = var.project
  env     = var.env

  #security-group
  security_group = {
    name   = "codebuild-app"
    vpc_id = module.vpc.vpc_id
  }
}
