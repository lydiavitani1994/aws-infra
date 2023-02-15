#Public Route Table
resource "aws_route_table" "routetablepublic" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "rt-pubrt-arun"
  }

}

#Associate Public Route Table to Public Subnets
resource "aws_route_table_association" "pubrtas1" {
  subnet_id      = aws_subnet.pubsub1.id
  route_table_id = aws_route_table.routetablepublic.id
}

resource "aws_route_table_association" "pubrtas2" {
  subnet_id      = aws_subnet.pubsub2.id
  route_table_id = aws_route_table.routetablepublic.id
}

resource "aws_route_table_association" "pubrtas3" {
  subnet_id      = aws_subnet.pubsub3.id
  route_table_id = aws_route_table.routetablepublic.id
}


#Private Route Table
resource "aws_route_table" "routetableprivate" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ngw.id
  }

  tags = {
    Name = "rt-prirt-arun"
  }
}

#Associate Private Route Table to Private Subnets
resource "aws_route_table_association" "prirtas1" {
  subnet_id      = aws_subnet.prisub1.id
  route_table_id = aws_route_table.routetableprivate.id
}

resource "aws_route_table_association" "prirtas2" {
  subnet_id      = aws_subnet.prisub2.id
  route_table_id = aws_route_table.routetableprivate.id
}

resource "aws_route_table_association" "prirtas3" {
  subnet_id      = aws_subnet.prisub3.id
  route_table_id = aws_route_table.routetableprivate.id
}