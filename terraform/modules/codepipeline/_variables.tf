#modules/codepipeline/_variables.tf
#basic
variable "project" {
  description = "Name of project"
  type        = string
}
variable "env" {
  description = "Name of project environment"
  type        = string
}

#codepipeline
variable "codepipeline" {
  description = "All configuration to Provides a CodePipeline."
  type = object({
    name     = string
    role_arn = string
    artifact_stores = list(object({
      bucket_id   = string
      kms_key_arn = optional(string, null)
      region      = optional(string, null)
    }))
    stages = list(object({
      name = string
      actions = list(object({
        version          = number
        run_order        = number
        category         = string #Approval, Build, Deploy, Invoke, Source and Test.
        name             = string
        provider         = string
        input_artifacts  = optional(list(string), null)
        output_artifacts = optional(list(string), null)
        namespace        = optional(string, null)
        role_arn         = optional(string, null)
        region           = optional(string, null)
        configuration    = optional(map(any), {})
      }))
    }))

  })
}
