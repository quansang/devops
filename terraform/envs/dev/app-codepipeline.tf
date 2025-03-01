module "codepipeline_app" {
  source = "../../modules/codepipeline"
  #basic
  project = var.project
  env     = var.env

  #codepipeline
  codepipeline = {
    name     = "app"
    role_arn = module.iam_role_codepipeline.iam_role_arn
    artifact_stores = [
      {
        bucket_id = module.s3_artifacts.s3_bucket_id
      }
    ]
    stages = [
      {
        name = "Source-App"
        actions = [
          {
            version          = 1
            run_order        = 1
            category         = "Source"
            name             = "Source-App-Github"
            provider         = "CodeStarSourceConnection"
            output_artifacts = ["source-app"]
            configuration = {
              ConnectionArn        = module.codestar_connection.codestar_connection_arn
              FullRepositoryId     = var.repo_name.app
              BranchName           = var.branch_name
              DetectChanges        = true
              OutputArtifactFormat = "CODE_ZIP"
            }
          }
        ]
      },
      {
        name = "Build-App"
        actions = [
          {
            version          = 1
            run_order        = 1
            category         = "Build"
            name             = "Build-App-Image"
            provider         = "CodeBuild"
            input_artifacts  = ["source-app"]
            output_artifacts = ["build-app"]
            configuration = {
              ProjectName = module.codebuild_app.codebuild_name
            }
          }
        ]
      },
      {
        name = "Deploy-App"
        actions = [
          {
            version         = 1
            run_order       = 1
            category        = "Deploy"
            name            = "Deploy-App-BlueGreen"
            provider        = "CodeDeployToECS"
            input_artifacts = ["build-app"]
            configuration = {
              ApplicationName                = module.codedeploy_app.codedeploy_app_name
              DeploymentGroupName            = module.codedeploy_app.codedeploy_deployment_group_name["bluegreen"]
              AppSpecTemplateArtifact        = "build-app"
              TaskDefinitionTemplateArtifact = "build-app"
              Image1ArtifactName             = "build-app"
              Image1ContainerName            = "IMAGE1_NAME"
            }
          }
        ]
      }
    ]
  }
}
