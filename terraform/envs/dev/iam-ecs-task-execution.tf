module "iam_role_ecs_task_execution" {
  source = "../../modules/iam-role"
  #basic
  project = var.project
  env     = var.env

  #iam-role
  name               = "ecs-task-execution"
  service            = "ecs"
  assume_role_policy = data.aws_iam_policy_document.assume_role_ecs.json
  iam_custom_policy = {
    template = jsonencode(
      {
        "Version" : "2012-10-17",
        "Statement" : [
          {
            "Effect" : "Allow",
            "Action" : [
              "ecr:GetAuthorizationToken",
              "ecr:BatchCheckLayerAvailability",
              "ecr:GetDownloadUrlForLayer",
              "ecr:BatchGetImage",
              "logs:CreateLogGroup",
              "logs:CreateLogStream",
              "logs:PutLogEvents",
              "logs:DescribeLogStreams"
            ],
            "Resource" : "*"
          }
        ]
      }
    )
  }
}
