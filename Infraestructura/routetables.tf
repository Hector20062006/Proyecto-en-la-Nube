# Rutas para subnets públicas en ambas VPCs hacia Internet Gateway
resource "aws_route" "vpc-1-public-internet" {
  route_table_id         = aws_route_table.vpc-1-public-route-table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.vpc-1-igw.id
}

resource "aws_route" "vpc-2-public-internet" {
  route_table_id         = aws_route_table.vpc-2-public-route-table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.vpc-2-igw.id
}

#Rutas para VPC Peering y NAT Gateway en subnets privadas

resource "aws_route" "vpc1_private_nat" {
  route_table_id         = aws_route_table.vpc-1-private-route-table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.vpc1_nat.id
}

resource "aws_route" "vpc2_private_nat" {
  route_table_id         = aws_route_table.vpc-2-private-route-table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.vpc2_nat.id
}

# Rutas para comunicación entre VPCs a través de VPC Peering

resource "aws_route" "vpc-1-private-to-vpc-2" {
  route_table_id            = aws_route_table.vpc-1-private-route-table.id
  destination_cidr_block    = "10.2.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc-1-vpc-2-peering.id
}

resource "aws_route" "vpc-2-private-to-vpc-1" {
  route_table_id            = aws_route_table.vpc-2-private-route-table.id
  destination_cidr_block    = "10.1.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc-1-vpc-2-peering.id
}
