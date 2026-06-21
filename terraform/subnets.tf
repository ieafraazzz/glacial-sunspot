# ==============================================================================
# Subnets for Main Banking VPC
# Secure Multi-VPC Banking Microservices Architecture
# ==============================================================================

# ------------------------------------------------------------------------------
# Public Subnet (Transaction-Service)
# ------------------------------------------------------------------------------
# This subnet is public and hosts the Transaction-Service
# It has direct internet access via the Internet Gateway

resource "aws_subnet" "main_public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.main_public_subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = merge(var.common_tags, {
    Name    = "main-public-subnet"
    Type    = "Public"
    Service = "Transaction-Service"
  })
}

# ------------------------------------------------------------------------------
# Private Subnet (Account-Service)
# ------------------------------------------------------------------------------
# This subnet is private and hosts the Account-Service
# It has no direct internet access, only internal VPC communication

resource "aws_subnet" "main_private" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.main_private_subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = false

  tags = merge(var.common_tags, {
    Name    = "main-private-subnet"
    Type    = "Private"
    Service = "Account-Service"
  })
}
