resource "random_string" "suffix" {
  length  = 16
  upper = false
  special = false
}

locals {
  bucket_name = "yumeng-s3-bucket-${terraform.workspace}-${random_string.suffix.result}"
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = local.bucket_name
  force_destroy = true

  tags = {
    Name        = local.bucket_name
    # Environment = "Dev"
  }
}

resource "aws_s3_bucket_public_access_block" "s3_bucket_public_access_block" {
  bucket = aws_s3_bucket.s3_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_acl" "s3_bucket_acl" {
  bucket = aws_s3_bucket.s3_bucket.id
  acl    = var.acl
}

resource "aws_s3_bucket_lifecycle_configuration" "lifecycle" {
  bucket = aws_s3_bucket.s3_bucket.id
  rule {
    id      = "transition_STANDARD_IA_30"
    status  = "Enabled"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    # filter {
    #   prefix = ""
    # }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.s3_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      # kms_master_key_id = aws_kms_key.mykey.arn
      sse_algorithm     = var.sse_algorithm
    }
  }
}
