module "iam_role_codebuild" {
  source = "../../modules/iam-role"
  #basic
  project = var.project
  env     = var.env

  #iam-role
  name               = "codebuild"
  service            = "codebuild"
  assume_role_policy = data.aws_iam_policy_document.assume_role_codebuild.json
  iam_custom_policy = {
    template = jsonencode(
      {
        "Version" : "2012-10-17",
        "Statement" : [
          {
            "Sid" : "CloudWatchLogsPolicy",
            "Effect" : "Allow",
            "Action" : [
              "logs:CreateLogGroup",
              "logs:CreateLogStream",
              "logs:PutLogEvents",
              "logs:DescribeLogGroups",
              "logs:PutRetentionPolicy",
              "logs:DeleteRetentionPolicy"
            ],
            "Resource" : [
              "*"
            ]
          },
          {
            "Sid" : "S3PutObjectPolicy",
            "Effect" : "Allow",
            "Action" : [
              "s3:List*",
              "s3:Get*",
              "s3:GetEncryptionConfiguration",
              "s3:PutObject",
              "s3:DeleteObject"
            ],
            "Resource" : "*"
          },
          {
            "Effect" : "Allow",
            "Action" : [
              "ssm:DescribeAssociation",
              "ssm:GetDeployablePatchSnapshotForInstance",
              "ssm:GetDocument",
              "ssm:DescribeDocument",
              "ssm:GetManifest",
              "ssm:GetParameter",
              "ssm:GetParameters",
              "ssm:PutParameter",
              "ssm:ListAssociations",
              "ssm:ListInstanceAssociations",
              "ssm:PutInventory",
              "ssm:PutComplianceItems",
              "ssm:PutConfigurePackageResult",
              "ssm:UpdateAssociationStatus",
              "ssm:UpdateInstanceAssociationStatus",
              "ssm:UpdateInstanceInformation",
              "ssm:SendCommand",
              "ssm:ListCommands"
            ],
            "Resource" : "*"
          },
          {
            "Effect" : "Allow",
            "Action" : [
              "ssmmessages:CreateControlChannel",
              "ssmmessages:CreateDataChannel",
              "ssmmessages:OpenControlChannel",
              "ssmmessages:OpenDataChannel"
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
            "Sid" : "AllowECRAuth",
            "Effect" : "Allow",
            "Action" : "ecr:GetAuthorizationToken",
            "Resource" : "*"
          },
          {
            "Sid" : "AllowECRUpload",
            "Effect" : "Allow",
            "Action" : [
              "ecr:UploadLayerPart",
              "ecr:PutImage",
              "ecr:InitiateLayerUpload",
              "ecr:GetDownloadUrlForLayer",
              "ecr:CompleteLayerUpload",
              "ecr:BatchGetImage",
              "ecr:BatchCheckLayerAvailability"
            ],
            "Resource" : "*"
          },
          {
            "Effect" : "Allow",
            "Action" : [
              "ec2:CreateNetworkInterface",
              "ec2:DescribeDhcpOptions",
              "ec2:DescribeNetworkInterfaces",
              "ec2:DeleteNetworkInterface",
              "ec2:DescribeSubnets",
              "ec2:DescribeSecurityGroups",
              "ec2:DescribeVpcs"
            ],
            "Resource" : "*"
          },
          {
            "Effect" : "Allow",
            "Action" : [
              "ec2:CreateNetworkInterfacePermission"
            ],
            "Resource" : "arn:aws:ec2:${var.region}:${var.account_id}:network-interface/*",
            "Condition" : {
              "StringEquals" : {
                "ec2:AuthorizedService" : "codebuild.amazonaws.com"
              },
              "ArnEquals" : {
                "ec2:Subnet" : [
                  "arn:aws:ec2:${var.region}:${var.account_id}:subnet/*",
                ]
              }
            }
          }
        ]
      }
    )
  }
}
