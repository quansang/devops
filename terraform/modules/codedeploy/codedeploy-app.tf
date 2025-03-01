resource "aws_codedeploy_app" "codedeploy_app" {
  count = (var.codedeploy_app != null && var.codedeploy_app_name == null) ? 1 : 0

  name             = "${var.project}-${var.env}-${var.codedeploy_app.name}-codedeploy-app"
  compute_platform = var.codedeploy_app.compute_platform

  tags = {
    Name = "${var.project}-${var.env}-${var.codedeploy_app.name}-codedeploy-app"
  }
}
