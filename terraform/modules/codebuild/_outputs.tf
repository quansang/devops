#modules/codebuild/_outputs.tf
output "codebuild_name" {
  description = "Name of the CodeBuild project."
  value       = aws_codebuild_project.codebuild.name
}
output "codebuild_arn" {
  description = "ARN of the CodeBuild project."
  value       = aws_codebuild_project.codebuild.arn
}
