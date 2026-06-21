# ==============================================================================
# Variables Definition
# Secure Multi-VPC Banking Microservices Architecture
# ==============================================================================

# ------------------------------------------------------------------------------
# General Configuration
# ------------------------------------------------------------------------------

variable "aws_region" {
  description = "AWS region for all resources"
  type        = string
  default     = "eu-north-1"
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "production"
}

# ------------------------------------------------------------------------------
# Main Banking VPC Configuration
# ------------------------------------------------------------------------------

variable "main_vpc_cidr" {
  description = "CIDR block for the Main Banking VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "main_public_subnet_cidr" {
  description = "CIDR block for the public subnet in Main VPC (Transaction-Service)"
  type        = string
  default     = "10.0.1.0/24"
}

variable "main_private_subnet_cidr" {
  description = "CIDR block for the private subnet in Main VPC (Account-Service)"
  type        = string
  default     = "10.0.2.0/24"
}

# ------------------------------------------------------------------------------
# Backup VPC Configuration
# ------------------------------------------------------------------------------

variable "backup_vpc_cidr" {
  description = "CIDR block for the Backup VPC (Highly Secure)"
  type        = string
  default     = "10.1.0.0/16"
}

variable "backup_private_subnet_cidr" {
  description = "CIDR block for the private subnet in Backup VPC (Backup-Service)"
  type        = string
  default     = "10.1.1.0/24"
}

# ------------------------------------------------------------------------------
# Availability Zone Configuration
# ------------------------------------------------------------------------------

variable "availability_zone" {
  description = "Availability zone for subnets"
  type        = string
  default     = "eu-north-1a"
}

# ------------------------------------------------------------------------------
# Security Configuration
# ------------------------------------------------------------------------------

variable "ssh_allowed_ip" {
  description = "IP address allowed for SSH access (use your public IP)"
  type        = string
  default     = "0.0.0.0/0"  # Placeholder - replace with your actual IP for security
}

# ------------------------------------------------------------------------------
# Common Tags
# ------------------------------------------------------------------------------

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    Project     = "Secure-Banking-Microservices"
    Architecture = "Multi-VPC-Peering"
  }
}

variable "key_name" {
  description = "Name of the SSH key pair to use for EC2 instances"
  type        = string
}
