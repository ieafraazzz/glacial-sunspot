# ==============================================================================
# Provider Configuration
# Secure Multi-VPC Banking Microservices Architecture
# ==============================================================================

terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# AWS Provider Configuration
# Region: eu-north-1 (Stockholm)
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "Secure-Banking-VPC"
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}
