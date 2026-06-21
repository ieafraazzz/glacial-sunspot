# ==============================================================================
# Backup VPC (Highly Secure)
# Secure Multi-VPC Banking Microservices Architecture
# ==============================================================================
# This VPC is designed for maximum security:
# - NO Internet Gateway
# - NO NAT Gateway
# - Private subnet only
# - Access only via VPC Peering from Main VPC
# ==============================================================================

# ------------------------------------------------------------------------------
# Backup VPC
# ------------------------------------------------------------------------------

resource "aws_vpc" "backup" {
  cidr_block           = var.backup_vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(var.common_tags, {
    Name     = "backup-vpc"
    Type     = "Backup"
    Security = "High"
  })
}

# ------------------------------------------------------------------------------
# Private Subnet (Backup-Service)
# ------------------------------------------------------------------------------
# This subnet hosts the Backup-Service
# Completely isolated from the internet

resource "aws_subnet" "backup_private" {
  vpc_id                  = aws_vpc.backup.id
  cidr_block              = var.backup_private_subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = false

  tags = merge(var.common_tags, {
    Name    = "backup-private-subnet"
    Type    = "Private"
    Service = "Backup-Service"
  })
}

# ------------------------------------------------------------------------------
# Private Route Table for Backup VPC
# ------------------------------------------------------------------------------
# Only local traffic and peering routes - no internet access

resource "aws_route_table" "backup_private" {
  vpc_id = aws_vpc.backup.id

  # Note: VPC peering route will be added in vpc_peering.tf
  # Local route (10.1.0.0/16) is automatically added by AWS

  tags = merge(var.common_tags, {
    Name = "backup-private-rt"
    Type = "Private"
  })
}

# Associate private route table with backup private subnet
resource "aws_route_table_association" "backup_private" {
  subnet_id      = aws_subnet.backup_private.id
  route_table_id = aws_route_table.backup_private.id
}
