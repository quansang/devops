module "iam_role_codedeploy" {
  source = "../../modules/iam-role"
  #basic
  project = var.project
  env     = var.env

  #iam-role
  name                   = "codedeploy"
  service                = "codedeploy"
  assume_role_policy     = data.aws_iam_policy_document.assume_role_codedeploy.json
  iam_default_policy_arn = ["arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"]
}
