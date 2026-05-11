# Creates a single AWS S3 bucket named sh-1235gg in us-east-1 with tags. (Note: S3 encrypts at rest by default; additional bucket-level encryption configuration not added unless explicitly requested.)
# Generated Terraform code for AWS in us-east-1

terraform {
  required_version = ">= 1.14.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 6.25.0"
    }
  }
}

variable "bucket_name" {
  description = "Name of the S3 bucket to create."
  type        = string
  default     = "sh-1235gg"
  validation {
    condition     = length(var.bucket_name) >= 3 && length(var.bucket_name) <= 63
    error_message = "S3 bucket name must be between 3 and 63 characters."
  }
}

variable "force_destroy" {
  description = "Whether to allow Terraform to destroy the bucket even if it contains objects."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply to the bucket."
  type        = map(string)
  default = {
    Environment = "prod"
    ManagedBy   = "terraform"
  }
}

provider "aws" {
  {{block_to_replace_cred}}

  region = "us-east-1"
}

resource "aws_s3_bucket" "this" {
  bucket        = var.bucket_name
  force_destroy = var.force_destroy

  tags = var.tags
}

output "bucket_id" {
  description = "ID (name) of the created S3 bucket."
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "ARN of the created S3 bucket."
  value       = aws_s3_bucket.this.arn
}