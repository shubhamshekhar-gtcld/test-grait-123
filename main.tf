# Creates a single EC2 instance named test-123 in us-east-1 using the provided AMI and instance type, with no public IP, termination protection enabled, detailed monitoring disabled, and IMDS http_tokens set to optional. Root block device uses provider/AWS defaults (size/type).
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

variable "ami_id" {
  description = "AMI ID to use for the EC2 instance."
  type        = string
  default     = "ami-0ed094fb1304fd857"

  validation {
    condition     = can(regex("^ami-[a-z0-9]+$", var.ami_id))
    error_message = "ami_id must look like an AMI ID (e.g., ami-xxxxxxxxxxxxxxxxx)."
  }
}

variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address to the primary network interface."
  type        = bool
  default     = false
}

variable "disable_api_termination" {
  description = "If true, enables EC2 termination protection."
  type        = bool
  default     = true
}

variable "ebs_optimized" {
  description = "If true, requests an EBS-optimized instance (only supported on some instance types)."
  type        = bool
  default     = true
}

variable "http_tokens" {
  description = "IMDSv2 setting for metadata service. Valid values: optional, required."
  type        = string
  default     = "optional"

  validation {
    condition     = contains(["optional", "required"], var.http_tokens)
    error_message = "http_tokens must be one of: optional, required."
  }
}

variable "instance_name" {
  description = "Name tag for the EC2 instance."
  type        = string
  default     = "test-123"

  validation {
    condition     = length(var.instance_name) > 0
    error_message = "instance_name must not be empty."
  }
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Existing EC2 Key Pair name to enable SSH access."
  type        = string
  default     = "qwertyu"

  validation {
    condition     = length(var.key_name) > 0
    error_message = "key_name must not be empty."
  }
}

variable "monitoring" {
  description = "Whether detailed monitoring is enabled."
  type        = bool
  default     = false
}

variable "region" {
  description = "AWS region to deploy into."
  type        = string
  default     = "us-east-1"
}

variable "tags" {
  description = "Additional tags to apply to resources."
  type        = map(string)
  default = {
    Environment = "prod"
    ManagedBy   = "terraform"
    Project     = "test-grait-123"
  }
}

provider "aws" {
  region = var.region

  {{block_to_replace_cred}}
}

resource "aws_instance" "main" {
  ami                         = var.ami_id
  associate_public_ip_address = var.associate_public_ip_address
  disable_api_termination     = var.disable_api_termination
  ebs_optimized               = var.ebs_optimized
  instance_type               = var.instance_type
  key_name                    = var.key_name
  monitoring                  = var.monitoring

  metadata_options {
    http_tokens = var.http_tokens
  }

  root_block_device {}

  tags = merge(
    var.tags,
    {
      Name = var.instance_name
    }
  )
}

output "instance_id" {
  description = "ID of the EC2 instance."
  value       = aws_instance.main.id
}

output "instance_arn" {
  description = "ARN of the EC2 instance."
  value       = aws_instance.main.arn
}

output "private_ip" {
  description = "Private IPv4 address assigned to the instance."
  value       = aws_instance.main.private_ip
}