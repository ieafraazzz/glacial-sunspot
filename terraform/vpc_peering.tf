# ==============================================================================
# VPC Peering Connection
# Secure Multi-VPC Banking Microservices Architecture
# ==============================================================================
# Creates a peering connection between Main VPC and Backup VPC
# Enables secure communication between:
# - Main VPC private subnet (Account-Service) → Backup VPC (Backup-Service)
# - Backup VPC (Backup-Service) → Main VPC private subnet
# ==============================================================================

# ------------------------------------------------------------------------------
# VPC Peering Connection
# ------------------------------------------------------------------------------

resource "aws_vpc_peering_connection" "main_to_backup" {
  vpc_id      = aws_vpc.main.id      # Requester VPC
  peer_vpc_id = aws_vpc.backup.id    # Accepter VPC
  auto_accept = true                  # Auto-accept since both VPCs are in same account

  tags = merge(var.common_tags, {
    Name = "main-to-backup-peering"
  })
}

# ------------------------------------------------------------------------------
# Route from Main VPC Private Subnet to Backup VPC
# ------------------------------------------------------------------------------
# Allows traffic from Main VPC private subnet to reach Backup VPC

resource "aws_route" "main_to_backup" {
  route_table_id            = aws_route_table.main_private.id
  destination_cidr_block    = var.backup_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.main_to_backup.id
}

# ------------------------------------------------------------------------------
# Route from Backup VPC to Main VPC Private Subnet
# ------------------------------------------------------------------------------
# Allows traffic from Backup VPC to reach Main VPC private subnet

resource "aws_route" "backup_to_main" {
  route_table_id            = aws_route_table.backup_private.id
  destination_cidr_block    = var.main_private_subnet_cidr  # Only route to private subnet
  vpc_peering_connection_id = aws_vpc_peering_connection.main_to_backup.id
}
