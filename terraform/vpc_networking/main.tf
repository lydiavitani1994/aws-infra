#vpc resource
resource "aws_vpc" "vpc" {
  enable_dns_hostnames = true
  cidr_block = var.vpc_cidr
  tags = {
    Name = var.vpc_tag_name
  }
}

# data
data "aws_availability_zones" "available" {
  state = var.data_state
}

#Elastic IP for NAT Gateway resource
resource "aws_eip" "nat" {
    vpc = var.aws_eip_vpc
    tags = {
        Name = "${var.aws_eip_tag_name}_${aws_vpc.vpc.id}"
    }
}

#Internet Gateway
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc.id
    tags = {
        Name = "${var.aws_internet_gateway_tag_name}_${aws_vpc.vpc.id}"
    }
}

# subnet
locals {
  zone_size = length(data.aws_availability_zones.available.names)
}
module "public_subnet_1" {
  source  = "./subnet"

  cidr_block  = var.pub_sub1_cidr
  vpc_id = aws_vpc.vpc.id
  map_public_ip_on_launch = true
  availability_zone = data.aws_availability_zones.available.names[0 % local.zone_size]
  tag_name = "public_subnet_1_${aws_vpc.vpc.id}"
}

module "public_subnet_2" {
  source  = "./subnet"

  cidr_block  = var.pub_sub2_cidr
  vpc_id = aws_vpc.vpc.id
  map_public_ip_on_launch = true
  availability_zone = data.aws_availability_zones.available.names[1%local.zone_size]
  tag_name = "public_subnet_2_${aws_vpc.vpc.id}"
}

module "public_subnet_3" {
  source  = "./subnet"

  cidr_block  = var.pub_sub3_cidr
  vpc_id = aws_vpc.vpc.id
  map_public_ip_on_launch = true
  availability_zone = data.aws_availability_zones.available.names[2%local.zone_size]
  tag_name = "public_subnet_3_${aws_vpc.vpc.id}"
}

module "private_subnet_1" {
  source  = "./subnet"

  cidr_block  = var.pri_sub1_cidr
  vpc_id = aws_vpc.vpc.id
  map_public_ip_on_launch = false
  availability_zone = data.aws_availability_zones.available.names[0%local.zone_size]
  tag_name = "private_subnet_1_${aws_vpc.vpc.id}"
}

module "private_subnet_2" {
  source  = "./subnet"

  cidr_block  = var.pri_sub2_cidr
  vpc_id = aws_vpc.vpc.id
  map_public_ip_on_launch = false
  availability_zone = data.aws_availability_zones.available.names[1%local.zone_size]
  tag_name = "private_subnet_2_${aws_vpc.vpc.id}"
}

module "private_subnet_3" {
  source  = "./subnet"

  cidr_block  = var.pri_sub3_cidr
  vpc_id = aws_vpc.vpc.id
  map_public_ip_on_launch = false
  availability_zone = data.aws_availability_zones.available.names[2%local.zone_size]
  tag_name = "private_subnet_3_${aws_vpc.vpc.id}"
}

locals {
  private_subnet_ids = [module.private_subnet_1.subnet.id, module.private_subnet_2.subnet.id, module.private_subnet_3.subnet.id]
  public_subnet_ids = [module.public_subnet_1.subnet.id, module.public_subnet_2.subnet.id, module.public_subnet_3.subnet.id]
}

#NAT Gateway object and attachment of the Elastic IP Address from above
resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.nat.id
  subnet_id = module.public_subnet_1.subnet.id
  depends_on = [aws_internet_gateway.igw]
  tags = {
    Name = "ngw_${aws_vpc.vpc.id}"
  }
}

# route_table
module "public_route_table" {
  source  = "./public_route_table"

  vpc_id = aws_vpc.vpc.id
  gateway_id = aws_internet_gateway.igw.id
  tag_name = "public_route_table_${aws_vpc.vpc.id}"
}

module "private_route_table" {
  source  = "./private_route_table"

  vpc_id = aws_vpc.vpc.id
  # gateway_id = aws_nat_gateway.ngw.id
  tag_name = "private_route_table_${aws_vpc.vpc.id}"
}


# Associate Route Table to Subnets
module "public_route_table_a_1" {
  source  = "./route_table_association"

  subnet_id = module.public_subnet_1.subnet.id
  route_table_id = module.public_route_table.route_table.id
}

module "public_route_table_a_2" {
  source  = "./route_table_association"

  subnet_id = module.public_subnet_2.subnet.id
  route_table_id = module.public_route_table.route_table.id
}

module "public_route_table_a_3" {
  source  = "./route_table_association"

  subnet_id = module.public_subnet_3.subnet.id
  route_table_id = module.public_route_table.route_table.id
}

module "private_route_table_a_1" {
  source  = "./route_table_association"

  subnet_id = module.private_subnet_1.subnet.id
  route_table_id = module.private_route_table.route_table.id
}

module "private_route_table_a_2" {
  source  = "./route_table_association"

  subnet_id = module.private_subnet_2.subnet.id
  route_table_id = module.private_route_table.route_table.id
}

module "private_route_table_a_3" {
  source  = "./route_table_association"

  subnet_id = module.private_subnet_3.subnet.id
  route_table_id = module.private_route_table.route_table.id
}






