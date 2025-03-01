resource "aws_s3_bucket" "s3_bucket" {
  bucket        = var.s3_bucket.name
  force_destroy = true

  tags = {
    Name = var.s3_bucket.name
  }
}

#S3 Bucket Configurations
resource "aws_s3_bucket_ownership_controls" "s3_bucket_ownership" {
  bucket = aws_s3_bucket.s3_bucket.id

  rule {
    object_ownership = var.s3_bucket.object_ownership
  }
}

resource "aws_s3_bucket_logging" "s3_bucket_logging" {
  count = var.s3_bucket.logging != null ? 1 : 0

  bucket        = aws_s3_bucket.s3_bucket.id
  target_bucket = var.s3_bucket.logging.target_bucket_id
  target_prefix = "s3-logs/${var.s3_bucket.name}/${var.s3_bucket.name}"
}

resource "aws_s3_bucket_public_access_block" "s3_bucket_pab" {
  bucket                  = aws_s3_bucket.s3_bucket.id
  block_public_acls       = var.s3_bucket.public_access_block
  block_public_policy     = var.s3_bucket.public_access_block
  ignore_public_acls      = var.s3_bucket.public_access_block
  restrict_public_buckets = var.s3_bucket.public_access_block
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_bucket_sse" {
  count = var.s3_bucket.sse != null ? 1 : 0

  bucket = aws_s3_bucket.s3_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = var.s3_bucket.sse.sse_algorithm
      kms_master_key_id = var.s3_bucket.sse.kms_master_key_id
    }
  }
}

resource "aws_s3_bucket_versioning" "s3_bucket_versioning" {
  bucket = aws_s3_bucket.s3_bucket.id
  versioning_configuration {
    status = var.s3_bucket.versioning
  }
}

resource "aws_s3_bucket_cors_configuration" "s3_bucket_cors" {
  count = length(var.s3_bucket.cors_rule) > 0 ? 1 : 0

  bucket = aws_s3_bucket.s3_bucket.id
  dynamic "cors_rule" {
    for_each = var.s3_bucket.cors_rule

    content {
      allowed_headers = cors_rule.value.allowed_headers
      allowed_methods = cors_rule.value.allowed_methods
      allowed_origins = cors_rule.value.allowed_origins
      expose_headers  = cors_rule.value.expose_headers
      max_age_seconds = cors_rule.value.max_age_seconds
    }
  }
}

resource "aws_s3_bucket_website_configuration" "s3_bucket_web" {
  count = var.s3_bucket.website_config ? 1 : 0

  bucket = aws_s3_bucket.s3_bucket.id

  index_document {
    suffix = "index.html"
  }
}
