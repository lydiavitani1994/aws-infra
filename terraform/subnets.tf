#Public Subnet 1
resource "aws_subnet" "pubsub1" {
  cidr_block              = var.pub_sub1_cidr
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[0]
  #0 indicates the first AZ
  tags = {
    Name = "pubsub1"
  }
}

#Public Subnet 2
resource "aws_subnet" "pubsub2" {
  cidr_block              = var.pub_sub2_cidr
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[1]
  #1 indicates the second AZ
  tags = {
    Name = "pubsub2"
  }
}

#Public Subnet 3

resource "aws_subnet" "pubsub3" {
  cidr_block              = var.pub_sub3_cidr
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[2]
  #2 indicates the 3rd AZ
  tags = {
    Name = "pubsub3"
  }
}

#Private Subnet 1
resource "aws_subnet" "prisub1" {
  cidr_block              = var.pri_sub1_cidr
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "prisub1"
  }
}

#Private Subnet 2
resource "aws_subnet" "prisub2" {
  cidr_block              = var.pri_sub2_cidr
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[1]
  tags = {
    Name = "prisub2"
  }
}

#Private Subnet 3
resource "aws_subnet" "prisub3" {
  cidr_block              = var.pri_sub3_cidr
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[2]
  tags = {
    Name = "prisub3"
  }
}