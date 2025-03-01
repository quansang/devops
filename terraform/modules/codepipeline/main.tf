resource "aws_codepipeline" "codepipeline" {
  name     = "${var.project}-${var.env}-${var.codepipeline.name}-codepipeline"
  role_arn = var.codepipeline.role_arn

  dynamic "artifact_store" {
    for_each = var.codepipeline.artifact_stores

    content {
      location = artifact_store.value.bucket_id
      type     = "S3"

      dynamic "encryption_key" {
        for_each = artifact_store.value.kms_key_arn != null ? [1] : []

        content {
          id   = artifact_store.value.kms_key_arn
          type = "KMS"
        }
      }
      region = artifact_store.value.region
    }
  }

  dynamic "stage" {
    for_each = var.codepipeline.stages

    content {
      name = stage.value.name

      dynamic "action" {
        for_each = stage.value.actions

        content {
          owner            = "AWS"
          version          = action.value.version
          run_order        = action.value.run_order
          category         = action.value.category
          name             = action.value.name
          provider         = action.value.provider
          input_artifacts  = action.value.input_artifacts
          output_artifacts = action.value.output_artifacts
          namespace        = action.value.namespace
          role_arn         = action.value.role_arn
          region           = action.value.region
          configuration    = action.value.configuration
        }
      }
    }
  }

  tags = {
    Name = "${var.project}-${var.env}-${var.codepipeline.name}-codepipeline"
  }
}
