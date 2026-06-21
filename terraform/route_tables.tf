# ==============================================================================
# Route Tables for Main Banking VPC
# Secure Multi-VPC Banking Microservices Architecture
# ==============================================================================

# ------------------------------------------------------------------------------
# Public Route Table
# ------------------------------------------------------------------------------
# Routes internet traffic (0.0.0.0/0) to the Internet Gateway
# Used by the public subnet hosting Transaction-Service

resource "aws_route_table" "main_public" {
  vpc_id = aws_vpc.main.id

  # Route all internet traffic to the Internet Gateway
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(var.common_tags, {
    Name = "main-public-rt"
    Type = "Public"
  })
}

# Associate public route table with public subnet
resource "aws_route_table_association" "main_public" {
  subnet_id      = aws_subnet.main_public.id
  route_table_id = aws_route_table.main_public.id
}

# ------------------------------------------------------------------------------
# Private Route Table
# ------------------------------------------------------------------------------
# Only local VPC traffic and peering routes
# No internet access - used by Account-Service

resource "aws_route_table" "main_private" {
  vpc_id = aws_vpc.main.id

  # Note: VPC peering route will be added in vpc_peering.tf
  # Local route (10.0.0.0/16) is automatically added by AWS

  tags = merge(var.common_tags, {
    Name = "main-private-rt"
    Type = "Private"
  })
}

# Associate private route table with private subnet
resource "aws_route_table_association" "main_private" {
  subnet_id      = aws_subnet.main_private.id
  route_table_id = aws_route_table.main_private.id
}
