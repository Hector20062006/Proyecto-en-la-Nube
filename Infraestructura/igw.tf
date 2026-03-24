#Internet Gateway para cada VPC
resource "aws_internet_gateway" "vpc-1-igw" {
  vpc_id = aws_vpc.vpc-1.id
  tags = { Name = "${var.vpc_1_name}-igw" }
}

resource "aws_internet_gateway" "vpc-2-igw" {
  vpc_id = aws_vpc.vpc-2.id
  tags = { Name = "${var.vpc_2_name}-igw" }
}

# Elastic IPs para los NAT Gateways

resource "aws_eip" "vpc1_nat_eip" {
  domain = "vpc"
  tags = { Name = "${var.vpc_1_name}-nat-eip" }
}

resource "aws_eip" "vpc2_nat_eip" {
  domain = "vpc"
  tags = { Name = "${var.vpc_2_name}-nat-eip" }
}

# NAT Gateway para cada VPC

resource "aws_nat_gateway" "vpc1_nat" {
  allocation_id = aws_eip.vpc1_nat_eip.id
  subnet_id     = aws_subnet.vpc-1-public-subnet.id
  depends_on = [aws_internet_gateway.vpc-1-igw]
  tags = aws_eip.vpc1_nat_eip.tags
}

resource "aws_nat_gateway" "vpc2_nat" {
  allocation_id = aws_eip.vpc2_nat_eip.id
  subnet_id     = aws_subnet.vpc-2-public-subnet.id
  depends_on = [aws_internet_gateway.vpc-2-igw]
  tags = aws_eip.vpc2_nat_eip.tags

}
