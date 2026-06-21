# ==============================================================================
# Internet Gateway for Main Banking VPC
# Secure Multi-VPC Banking Microservices Architecture
# ==============================================================================
# The Internet Gateway provides internet connectivity for the public subnet
# This allows the Transaction-Service to receive incoming customer requests
# ==============================================================================

# ------------------------------------------------------------------------------
# Internet Gateway
# ------------------------------------------------------------------------------

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.common_tags, {
    Name = "main-banking-igw"
  })
}
