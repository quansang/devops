#modules/security-group/_variables.tf
#basic
variable "project" {
  description = "Name of project"
  type        = string
}
variable "env" {
  description = "Name of project environment"
  type        = string
}

#security-group
variable "security_group" {
  description = "Provides a security group resource."
  default     = null
  type = object({
    name   = string
    vpc_id = string
    egress_rules = optional(list(object({
      from_port       = number
      to_port         = number
      protocol        = string
      description     = string
      cidr_blocks     = optional(list(string), [])
      security_groups = optional(list(string), [])
      prefix_list_ids = optional(list(string), [])
      self            = optional(bool, false)
      })),
      [{
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        description = "Allow all egress traffic"
        cidr_blocks = ["0.0.0.0/0"]
      }]
    )
    ingress_rules = optional(list(object({
      from_port       = number
      to_port         = number
      protocol        = string
      description     = string
      cidr_blocks     = optional(list(string), [])
      security_groups = optional(list(string), [])
      prefix_list_ids = optional(list(string), [])
      self            = optional(bool, false)
    })), [])
  })
}
