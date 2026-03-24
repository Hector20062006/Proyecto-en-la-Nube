#Subnets and Route Tables for VPC Peering
resource "aws_subnet" "vpc-1-public-subnet" { 
    vpc_id = aws_vpc.vpc-1.id 
    cidr_block = "10.1.1.0/24"
    map_public_ip_on_launch = true
    tags = { Name = "${var.vpc_1_name}-public-subnet" }
}

resource "aws_subnet" "vpc-1-private-subnet" { 
    vpc_id = aws_vpc.vpc-1.id 
    cidr_block = "10.1.2.0/24"
    tags = { Name = "${var.vpc_1_name}-private-subnet" }
}

resource "aws_subnet" "vpc-2-public-subnet" { 
    vpc_id = aws_vpc.vpc-2.id 
    cidr_block = "10.2.1.0/24" 
    map_public_ip_on_launch = true
    tags = { Name = "${var.vpc_2_name}-public-subnet" }
}

resource "aws_subnet" "vpc-2-private-subnet" { 
    vpc_id = aws_vpc.vpc-2.id 
    cidr_block = "10.2.2.0/24" 
    tags = { Name = "${var.vpc_2_name}-private-subnet" }
}

# Tablas de rutas para cada VPC y tipo de subnet (pública/privada)

resource "aws_route_table" "vpc-1-public-route-table" {
  vpc_id = aws_vpc.vpc-1.id
  tags = { Name = "${var.vpc_1_name}-public-route-table" }
}

resource "aws_route_table" "vpc-1-private-route-table" {
  vpc_id = aws_vpc.vpc-1.id
  tags = { Name = "${var.vpc_1_name}-private-route-table" }
}

resource "aws_route_table" "vpc-2-public-route-table" {
  vpc_id = aws_vpc.vpc-2.id
  tags = { Name = "${var.vpc_2_name}-public-route-table" }
}

resource "aws_route_table" "vpc-2-private-route-table" {
  vpc_id = aws_vpc.vpc-2.id
  tags = { Name = "${var.vpc_2_name}-private-route-table" }
}

resource "aws_route" "vpc-1-public-to-vpc-2" {
  route_table_id            = aws_route_table.vpc-1-public-route-table.id
  destination_cidr_block    = "10.2.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc-1-vpc-2-peering.id
}

resource "aws_route" "vpc-2-public-to-vpc-1" {
  route_table_id            = aws_route_table.vpc-2-public-route-table.id
  destination_cidr_block    = "10.1.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc-1-vpc-2-peering.id
}


#Asociaciones de tablas de rutas a subnets

resource "aws_route_table_association" "vpc-1-private-subnet-association" {
  subnet_id      = aws_subnet.vpc-1-private-subnet.id
  route_table_id = aws_route_table.vpc-1-private-route-table.id
}

resource "aws_route_table_association" "vpc-1-public-subnet-association" {
  subnet_id      = aws_subnet.vpc-1-public-subnet.id
  route_table_id = aws_route_table.vpc-1-public-route-table.id
}

resource "aws_route_table_association" "vpc-2-public-subnet-association" {
  subnet_id      = aws_subnet.vpc-2-public-subnet.id
  route_table_id = aws_route_table.vpc-2-public-route-table.id
}

resource "aws_route_table_association" "vpc-2-private-subnet-association" {
  subnet_id      = aws_subnet.vpc-2-private-subnet.id
  route_table_id = aws_route_table.vpc-2-private-route-table.id
}