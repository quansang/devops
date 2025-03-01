#modules/ecr/_variables.tf
#basic
variable "project" {
  description = "Name of project"
  type        = string
}
variable "env" {
  description = "Name of project environment"
  type        = string
}

#ecr
variable "ecr" {
  description = "All configuration to Provides an Elastic Container Registry Repository."
  type = object({
    name                 = string
    image_tag_mutability = optional(string, "MUTABLE")
    force_delete         = optional(bool, true)
    scan_on_push         = optional(bool, false)
  })
}
