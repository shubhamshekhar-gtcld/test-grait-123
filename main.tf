# No functional infrastructure changes were made.
            # Modified Terraform Code for AWS in us-east-1

            terraform {
  required_version = ">= 1.14.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 6.25.0"
    }
  }
}

            variable "aws_region" {
  description = "AWS region to deploy into."
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Name of the S3 bucket."
  type        = string
  default     = "grait-123456"

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "bucket_name must be 3-63 characters, lowercase letters/numbers/hyphens, and start/end with a letter or number."
  }
}

variable "object_ownership" {
  description = "S3 object ownership setting (e.g., BucketOwnerEnforced)."
  type        = string
  default     = "BucketOwnerEnforced"

  validation {
    condition     = contains(["BucketOwnerEnforced", "BucketOwnerPreferred", "ObjectWriter"], var.object_ownership)
    error_message = "object_ownership must be one of: BucketOwnerEnforced, BucketOwnerPreferred, ObjectWriter."
  }
}

variable "block_public_acls" {
  description = "Whether Amazon S3 should block public ACLs for this bucket."
  type        = bool
  default     = true
}

variable "block_public_policy" {
  description = "Whether Amazon S3 should block public bucket policies for this bucket."
  type        = bool
  default     = true
}

variable "ignore_public_acls" {
  description = "Whether Amazon S3 should ignore public ACLs for this bucket."
  type        = bool
  default     = true
}

variable "restrict_public_buckets" {
  description = "Whether Amazon S3 should restrict public bucket policies for this bucket."
  type        = bool
  default     = true
}

variable "versioning_enabled" {
  description = "Whether S3 bucket versioning is enabled."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to resources."
  type        = map(string)
  default = {
    Environment = "prod"
    ManagedBy   = "terraform"
    Project     = "grait"
  }
}

            provider "aws" {
  {{block_to_replace_cred}}
  region = var.aws_region
}

resource "aws_s3_bucket" "main" {
  bucket = var.bucket_name

  # Add/override Environment tag specifically for this bucket without changing var.tags defaults
  tags = merge(var.tags, {
    Environment = "Dev"
  })
}

resource "aws_s3_bucket_ownership_controls" "main" {
  bucket = aws_s3_bucket.main.id

  rule {
    object_ownership = var.object_ownership
  }
}

resource "aws_s3_bucket_public_access_block" "main" {
  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  bucket                  = aws_s3_bucket.main.id
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}

resource "aws_s3_bucket_versioning" "main" {
  bucket = aws_s3_bucket.main.id

  versioning_configuration {
    status = var.versioning_enabled ? "Enabled" : "Suspended"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "main" {
  bucket = aws_s3_bucket.main.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

            output "s3_bucket_id" {
  description = "ID of the created S3 bucket (typically the bucket name)."
  value       = aws_s3_bucket.main.id
}

output "s3_bucket_arn" {
  description = "ARN of the created S3 bucket."
  value       = aws_s3_bucket.main.arn
}

output "s3_bucket_name" {
  description = "Name of the created S3 bucket."
  value       = aws_s3_bucket.main.bucket
}