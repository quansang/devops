#modules/s3/_variables.tf
#s3-bucket
variable "s3_bucket" {
  description = "All configurations to Provides a S3 bucket resource."
  type = object({
    name             = string
    object_ownership = optional(string, "BucketOwnerEnforced") #BucketOwnerPreferred(logging) or ObjectWriter
    sse = optional(object({
      kms_master_key_id = optional(string, null)
      sse_algorithm     = string
    }), null)
    versioning = optional(string, "Suspended")
    logging = optional(object({
      target_bucket_id = string
    }), null)
    public_access_block = optional(bool, true)
    website_config      = optional(bool, false)
    cors_rule = optional(list(object({
      allowed_headers = optional(list(string), ["*"])
      allowed_methods = optional(list(string), ["PUT", "POST"])
      allowed_origins = optional(list(string), ["*"])
      expose_headers  = optional(list(string), [])
      max_age_seconds = optional(number, 3000)
    })), [])
  })
}

#s3-bucket-policy
variable "s3_bucket_policy" {
  description = "Attaches a policy to an S3 bucket resource."
  default     = null
  type = object({
    template = string
  })
}
