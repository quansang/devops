#modules/codepipeline/_outputs.tf
output "codepipeline_arn" {
  description = "The codepipeline ARN."
  value       = aws_codepipeline.codepipeline.arn
}
output "codepipeline_name" {
  description = "The codepipeline name."
  value       = aws_codepipeline.codepipeline.name
}
