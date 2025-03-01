module "iam_role_codepipeline" {
  source = "../../modules/iam-role"
  #basic
  project = var.project
  env     = var.env

  #iam-role
  name               = "codepipeline"
  service            = "codepipeline"
  assume_role_policy = data.aws_iam_policy_document.assume_role_codepipeline.json
  iam_custom_policy = {
    template = jsonencode(
      {
        "Version" : "2012-10-17",
        "Statement" : [
          {

            "Sid" : "AllowS3",
            "Effect" : "Allow",
            "Action" : [
              "s3:PutObject",
              "s3:PutObjectAcl",
              "s3:ListBucket",
              "s3:GetObject",
              "s3:GetObjectVersion",
              "s3:GetBucketVersioning"
            ],
            "Resource" : "*"
          },
          {
            "Effect" : "Allow",
            "Action" : [
              "kms:DescribeKey",
              "kms:GenerateDataKey*",
              "kms:Encrypt",
              "kms:ReEncrypt*",
              "kms:Decrypt"
            ],
            "Resource" : "*"
          },
          {
            "Effect" : "Allow",
            "Action" : [
              "codebuild:BatchGetBuilds",
              "codebuild:StartBuild"
            ],
            "Resource" : "*"
          },
          {
            "Sid" : "AllowCodeDeploy",
            "Effect" : "Allow",
            "Action" : [
              "codedeploy:RegisterApplicationRevision",
              "codedeploy:GetDeploymentConfig",
              "codedeploy:GetDeployment",
              "codedeploy:GetApplicationRevision",
              "codedeploy:GetApplication",
              "codedeploy:CreateDeployment"
            ],
            "Resource" : "*"
          },
          {
            "Effect" : "Allow",
            "Action" : [
              "ecs:RegisterTaskDefinition"
            ],
            "Resource" : "*"
          },
          {
            "Action" : [
              "iam:PassRole"
            ],
            "Resource" : "*",
            "Effect" : "Allow",
            "Condition" : {
              "StringEqualsIfExists" : {
                "iam:PassedToService" : [
                  "ecs-tasks.amazonaws.com"
                ]
              }
            }
          },
          {
            "Effect" : "Allow",
            "Action" : [
              "codeconnections:UseConnection",
              "codestar-connections:UseConnection"
            ],
            "Resource" : [
              "arn:aws:codestar-connections:*:*:connection/*",
              "arn:aws:codeconnections:*:*:connection/*"
            ]
          }
        ]
      }
    )
  }
}
