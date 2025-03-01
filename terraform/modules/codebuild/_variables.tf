#modules/codebuild/_variables.tf
#basic
variable "project" {
  description = "Name of project"
  type        = string
}
variable "env" {
  description = "Name of project environment"
  type        = string
}

#codebuild
variable "codebuild" {
  description = "All configuration to Provides a CodeBuild Project resource."
  type = object({
    name           = string
    queued_timeout = optional(number, 480)
    build_timeout  = optional(number, 60)
    service_role   = string
    vpc = optional(object({
      id                 = string
      subnets            = list(string)
      security_group_ids = list(string)
    }), null)
    source = object({
      type      = optional(string, "CODEPIPELINE")
      buildspec = string
    })
    artifacts = optional(object({
      type = string
    }), { type = "CODEPIPELINE" })
    environment = object({
      compute_type                = string
      image                       = string
      type                        = optional(string, "LINUX_CONTAINER")
      image_pull_credentials_type = optional(string, "CODEBUILD")
      variables = optional(list(object({
        name  = string
        value = any
      })), [])
    })
    s3_logs = optional(object({
      encryption_disabled = bool
      status              = string
      }),
      {
        encryption_disabled = false
        status              = "DISABLED"
      }
    )
  })
}

#cloudwatch-log-group
variable "log_group_retention" {
  description = "Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653, and 0. If you select 0, the events in the log group are always retained and never expire."
  default     = 30
  type        = number
}
