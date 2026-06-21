# ==============================================================================
# Outputs
# Secure Multi-VPC Banking Microservices Architecture
# ==============================================================================

# ------------------------------------------------------------------------------
# VPC Outputs
# ------------------------------------------------------------------------------

output "main_vpc_id" {
  description = "ID of the Main Banking VPC"
  value       = aws_vpc.main.id
}

output "main_vpc_cidr" {
  description = "CIDR block of the Main Banking VPC"
  value       = aws_vpc.main.cidr_block
}

output "backup_vpc_id" {
  description = "ID of the Backup VPC"
  value       = aws_vpc.backup.id
}

output "backup_vpc_cidr" {
  description = "CIDR block of the Backup VPC"
  value       = aws_vpc.backup.cidr_block
}

# ------------------------------------------------------------------------------
# Subnet Outputs
# ------------------------------------------------------------------------------

output "main_public_subnet_id" {
  description = "ID of the Main VPC public subnet (Transaction-Service)"
  value       = aws_subnet.main_public.id
}

output "main_private_subnet_id" {
  description = "ID of the Main VPC private subnet (Account-Service)"
  value       = aws_subnet.main_private.id
}

output "backup_private_subnet_id" {
  description = "ID of the Backup VPC private subnet (Backup-Service)"
  value       = aws_subnet.backup_private.id
}

# ------------------------------------------------------------------------------
# Security Group Outputs
# ------------------------------------------------------------------------------

output "transaction_sg_id" {
  description = "ID of the Transaction Service security group"
  value       = aws_security_group.transaction_sg.id
}

output "account_sg_id" {
  description = "ID of the Account Service security group"
  value       = aws_security_group.account_sg.id
}

output "backup_sg_id" {
  description = "ID of the Backup Service security group"
  value       = aws_security_group.backup_sg.id
}

# ------------------------------------------------------------------------------
# VPC Peering Outputs
# ------------------------------------------------------------------------------

output "vpc_peering_connection_id" {
  description = "ID of the VPC peering connection between Main and Backup VPCs"
  value       = aws_vpc_peering_connection.main_to_backup.id
}

# ------------------------------------------------------------------------------
# Internet Gateway Output
# ------------------------------------------------------------------------------

output "internet_gateway_id" {
  description = "ID of the Internet Gateway (Main VPC)"
  value       = aws_internet_gateway.main.id
}

# ------------------------------------------------------------------------------
# Route Table Outputs
# ------------------------------------------------------------------------------

output "main_public_route_table_id" {
  description = "ID of the Main VPC public route table"
  value       = aws_route_table.main_public.id
}

output "main_private_route_table_id" {
  description = "ID of the Main VPC private route table"
  value       = aws_route_table.main_private.id
}

output "backup_private_route_table_id" {
  description = "ID of the Backup VPC private route table"
  value       = aws_route_table.backup_private.id
}
