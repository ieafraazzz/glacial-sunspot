# ==============================================================================
# Main Banking VPC
# Secure Multi-VPC Banking Microservices Architecture
# ==============================================================================
# This VPC hosts the primary banking services:
# - Transaction-Service (public subnet) - handles customer transactions
# - Account-Service (private subnet) - manages account data
# ==============================================================================

# ------------------------------------------------------------------------------
# Main Banking VPC
# ------------------------------------------------------------------------------

resource "aws_vpc" "main" {
  cidr_block           = var.main_vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(var.common_tags, {
    Name = "main-banking-vpc"
    Type = "Primary"
  })
}
