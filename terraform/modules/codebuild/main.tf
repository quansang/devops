resource "aws_codebuild_project" "codebuild" {
  name           = "${var.project}-${var.env}-${var.codebuild.name}-codebuild"
  description    = "Codebuild project for ${var.codebuild.name} in ${var.env} of ${var.project}"
  badge_enabled  = false
  queued_timeout = var.codebuild.queued_timeout
  build_timeout  = var.codebuild.build_timeout
  service_role   = var.codebuild.service_role

  dynamic "vpc_config" {
    for_each = var.codebuild.vpc != null ? [1] : []

    content {
      vpc_id             = var.codebuild.vpc.id
      subnets            = var.codebuild.vpc.subnets
      security_group_ids = var.codebuild.vpc.security_group_ids
    }
  }

  source {
    type                = var.codebuild.source.type
    insecure_ssl        = false
    report_build_status = false
    buildspec           = var.codebuild.source.buildspec #buildspec.yml
  }

  artifacts {
    encryption_disabled    = false
    override_artifact_name = false
    type                   = var.codebuild.artifacts.type
  }

  cache {
    type = "NO_CACHE"
  }

  environment {
    compute_type                = var.codebuild.environment.compute_type
    image                       = var.codebuild.environment.image
    type                        = var.codebuild.environment.type
    image_pull_credentials_type = var.codebuild.environment.image_pull_credentials_type
    privileged_mode             = "true"

    dynamic "environment_variable" {
      for_each = var.codebuild.environment.variables
      content {
        name  = environment_variable.value.name
        type  = "PLAINTEXT"
        value = environment_variable.value.value
      }
    }
  }

  logs_config {
    cloudwatch_logs {
      status     = "ENABLED"
      group_name = "/aws/codebuild/${var.project}-${var.env}-${var.codebuild.name}-codebuild"
    }

    s3_logs {
      encryption_disabled = var.codebuild.s3_logs.encryption_disabled
      status              = var.codebuild.s3_logs.status
    }
  }

  tags = {
    Name = "${var.project}-${var.env}-${var.codebuild.name}-codebuild"
  }
}

#cloudwatch-log-group
resource "aws_cloudwatch_log_group" "log_group" {
  name              = "/aws/codebuild/${aws_codebuild_project.codebuild.name}"
  retention_in_days = var.log_group_retention

  tags = {
    Name = aws_codebuild_project.codebuild.name
  }
}
