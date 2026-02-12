resource "aws_vpc" "vpc-1" { 
    cidr_block = "10.1.0.0/16"
    tags = { Name = "${var.vpc_1_name}" }
}
resource "aws_vpc" "vpc-2" {
    cidr_block = "10.2.0.0/16"
    tags = { Name = "${var.vpc_2_name}" }
}

resource "aws_vpc_peering_connection" "vpc-1-vpc-2-peering" {
  vpc_id      = aws_vpc.vpc-1.id
  peer_vpc_id = aws_vpc.vpc-2.id
  auto_accept = true

  tags = { Name = "peering-${var.vpc_1_name}-${var.vpc_2_name}" }
}