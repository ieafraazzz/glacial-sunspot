# ==============================================================================
# Security Groups
# Secure Multi-VPC Banking Microservices Architecture
# ==============================================================================

# ------------------------------------------------------------------------------
# Transaction Service Security Group (Main VPC - Public Subnet)
# ------------------------------------------------------------------------------
# Allows public access for customer transactions
# - HTTP (80) and app port (5000) from anywhere
# - SSH (22) from specified IP for management

resource "aws_security_group" "transaction_sg" {
  name        = "transaction-service-sg"
  description = "Security group for Transaction Service (public facing)"
  vpc_id      = aws_vpc.main.id

  # Allow HTTP traffic from anywhere
  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow application traffic on port 5000 from anywhere
  ingress {
    description = "App port 5000 from anywhere"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow SSH from specified IP (placeholder - update with your IP)
  ingress {
    description = "SSH from allowed IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_allowed_ip]
  }

  # Allow all outbound traffic
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {
    Name    = "transaction-service-sg"
    Service = "Transaction-Service"
  })
}

# ------------------------------------------------------------------------------
# Account Service Security Group (Main VPC - Private Subnet)
# ------------------------------------------------------------------------------
# Only allows traffic from within Main VPC
# - App port (5000) from Main VPC CIDR only

resource "aws_security_group" "account_sg" {
  name        = "account-service-sg"
  description = "Security group for Account Service (internal only)"
  vpc_id      = aws_vpc.main.id

  # Allow application traffic on port 5000 from Main VPC only
  ingress {
    description = "App port 5002 from Main VPC"
    from_port   = 5002
    to_port     = 5002
    protocol    = "tcp"
    cidr_blocks = [var.main_vpc_cidr]
  }

  # Allow SSH from Transaction Service subnet for management
  ingress {
    description = "SSH from public subnet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.main_public_subnet_cidr]
  }

  # Allow all outbound traffic
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {
    Name    = "account-service-sg"
    Service = "Account-Service"
  })
}

# ------------------------------------------------------------------------------
# Backup Service Security Group (Backup VPC - Private Subnet)
# ------------------------------------------------------------------------------
# Highly restrictive - only allows traffic from Main VPC private subnet
# - App port (5000) from Main VPC private subnet only

resource "aws_security_group" "backup_sg" {
  name        = "backup-service-sg"
  description = "Security group for Backup Service (highly restricted)"
  vpc_id      = aws_vpc.backup.id

  # Allow application traffic on port 5000 from Main VPC private subnet only
  ingress {
    description = "App port 5003 from Main VPC private subnet"
    from_port   = 5003
    to_port     = 5003
    protocol    = "tcp"
    cidr_blocks = [var.main_private_subnet_cidr]
  }

  # Allow SSH from Main VPC private subnet for management
  ingress {
    description = "SSH from Main VPC private subnet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.main_private_subnet_cidr]
  }

  # Allow outbound traffic to Main VPC private subnet only
  egress {
    description = "Allow outbound to Main VPC private subnet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.main_private_subnet_cidr]
  }

  tags = merge(var.common_tags, {
    Name     = "backup-service-sg"
    Service  = "Backup-Service"
    Security = "High"
  })
}
