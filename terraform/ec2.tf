# =============================================================================
# EC2 INSTANCES FOR BANKING MICROSERVICES
# Secure Multi-VPC Banking Microservices Architecture Using AWS VPC Peering
# =============================================================================
# This module provisions EC2 instances ONLY.
# All networking resources (VPCs, Subnets, Security Groups, etc.) are managed
# by a separate networking Terraform module.
# =============================================================================

# -----------------------------------------------------------------------------
# TERRAFORM CONFIGURATION
# -----------------------------------------------------------------------------


# -----------------------------------------------------------------------------
# PROVIDER CONFIGURATION
# -----------------------------------------------------------------------------


# -----------------------------------------------------------------------------
# VARIABLES - References to existing networking resources
# -----------------------------------------------------------------------------

# Key Pair for SSH access


# Variables removed as we are using direct resource references

# -----------------------------------------------------------------------------
# DATA SOURCE - Amazon Linux 2 AMI
# -----------------------------------------------------------------------------
# Fetches the latest Amazon Linux 2 AMI for eu-north-1 region
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

# -----------------------------------------------------------------------------
# EC2 INSTANCE 1: TRANSACTION SERVICE
# -----------------------------------------------------------------------------
# Purpose: Public REST API entry point for banking transactions
# Location: Public subnet with public IP enabled
# Access: Exposed to internet via transaction_sg security group
# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------
# EC2 INSTANCE 1: TRANSACTION SERVICE
# -----------------------------------------------------------------------------
resource "aws_instance" "transaction_service" {
  ami                         = data.aws_ami.amazon_linux_2.id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.main_public.id
  vpc_security_group_ids      = [aws_security_group.transaction_sg.id]
  key_name                    = var.key_name
  associate_public_ip_address = true

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 8
    delete_on_termination = true
    encrypted             = true
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "optional" # Changed to optional to avoid issues during initial setup if easy usage is preferred
    http_put_response_hop_limit = 1
  }

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y python3-pip git
              pip3 install flask flask-cors requests
              EOF

  tags = {
    Name        = "transaction-service-ec2"
    Environment = "production"
    Service     = "transaction"
    Project     = "banking-microservices"
    ManagedBy   = "terraform"
  }
}

# -----------------------------------------------------------------------------
# EC2 INSTANCE 2: ACCOUNT SERVICE
# -----------------------------------------------------------------------------
resource "aws_instance" "account_service" {
  ami                         = data.aws_ami.amazon_linux_2.id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.main_private.id
  vpc_security_group_ids      = [aws_security_group.account_sg.id]
  key_name                    = var.key_name
  associate_public_ip_address = false

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 8
    delete_on_termination = true
    encrypted             = true
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "optional"
    http_put_response_hop_limit = 1
  }

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y python3-pip git
              pip3 install flask requests
              EOF

  tags = {
    Name        = "account-service-ec2"
    Environment = "production"
    Service     = "account"
    Project     = "banking-microservices"
    ManagedBy   = "terraform"
  }
}

# -----------------------------------------------------------------------------
# EC2 INSTANCE 3: BACKUP SERVICE
# -----------------------------------------------------------------------------
resource "aws_instance" "backup_service" {
  ami                         = data.aws_ami.amazon_linux_2.id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.backup_private.id
  vpc_security_group_ids      = [aws_security_group.backup_sg.id]
  key_name                    = var.key_name
  associate_public_ip_address = false

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 8
    delete_on_termination = true
    encrypted             = true
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "optional"
    http_put_response_hop_limit = 1
  }

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y python3-pip git
              pip3 install flask
              EOF

  tags = {
    Name        = "backup-service-ec2"
    Environment = "production"
    Service     = "backup"
    Project     = "banking-microservices"
    ManagedBy   = "terraform"
  }
}

# -----------------------------------------------------------------------------
# OUTPUTS - EC2 Instance Information
# -----------------------------------------------------------------------------

# Transaction Service Outputs (Public)
output "transaction_ec2_public_ip" {
  description = "Public IP address of the Transaction Service EC2 instance"
  value       = aws_instance.transaction_service.public_ip
}

output "transaction_ec2_public_dns" {
  description = "Public DNS name of the Transaction Service EC2 instance"
  value       = aws_instance.transaction_service.public_dns
}

output "transaction_ec2_instance_id" {
  description = "Instance ID of the Transaction Service EC2"
  value       = aws_instance.transaction_service.id
}

# Account Service Outputs (Private)
output "account_ec2_private_ip" {
  description = "Private IP address of the Account Service EC2 instance"
  value       = aws_instance.account_service.private_ip
}

output "account_ec2_instance_id" {
  description = "Instance ID of the Account Service EC2"
  value       = aws_instance.account_service.id
}

# Backup Service Outputs (Private)
output "backup_ec2_private_ip" {
  description = "Private IP address of the Backup Service EC2 instance"
  value       = aws_instance.backup_service.private_ip
}

output "backup_ec2_instance_id" {
  description = "Instance ID of the Backup Service EC2"
  value       = aws_instance.backup_service.id
}
