#modules/codestar/_variables.tf
#basic
variable "project" {
  description = "Name of project"
  type        = string
}
variable "env" {
  description = "Name of project environment"
  type        = string
}

#codestar
variable "provider_type" {
  description = "The name of the external provider where your third-party code repository is configured. Valid values are Bitbucket, GitHub or GitHubEnterpriseServer."
  type        = string
  default     = "GitHub"
}
