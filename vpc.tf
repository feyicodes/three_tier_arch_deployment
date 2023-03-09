
# Declare the data source

data "aws_availability_zones" "available" {
  state = "available"
}


# Creating Local Block
locals {
  vpc_id = aws_vpc.my_vpc.id
  azs    = slice(data.aws_availability_zones.available.names, 0, 2)
}


# Creating VPC resources
resource "aws_vpc" "my_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  instance_tenancy     = "default"

  tags = {
    Name = "${var.component}_vpc"
  }
}





# Creating VPCs Public, Private and Database subnet

resource "aws_subnet" "public_subnet" {
  count = length(var.public_subnet_cidr_block)
  # vpc_id   = aws_vpc.my_vpc.id
  vpc_id                  = local.vpc_id
  cidr_block              = var.public_subnet_cidr_block[count.index]
  map_public_ip_on_launch = true
  availability_zone       = local.azs[count.index]

  tags = {
    Name = "${var.component}_public_subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  count = length(var.private_subnet_cidr_block)
  # vpc_id   = aws_vpc.my_vpc.id
  vpc_id            = local.vpc_id
  cidr_block        = var.private_subnet_cidr_block[count.index]
  availability_zone = local.azs[count.index]

  tags = {
    Name = "${var.component}_private_subnet"
  }
}

resource "aws_subnet" "database_subnet" {
  count = length(var.database_subnet_cidr_block)
  # vpc_id   = aws_vpc.my_vpc.id
  vpc_id            = local.vpc_id
  cidr_block        = var.database_subnet_cidr_block[count.index]
  availability_zone = local.azs[count.index]

  tags = {
    Name = "${var.component}_database_subnet"
  }
}

# Creating the Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = local.vpc_id

  tags = {
    Name = "${var.component}_igw"
  }

}

resource "aws_route_table" "public_route_table" {
  vpc_id = local.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }


  tags = {
    Name = "${var.component}_public_route_table"
  }
}

resource "aws_route_table_association" "public_association" {
  count          = length(aws_subnet.public_subnet)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_default_route_table" "default_route_table" {
  default_route_table_id = aws_vpc.my_vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "${var.component}_default_route_table"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  depends_on    = [aws_internet_gateway.igw]
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public_subnet[0].id

  tags = {
    Name = "gw NAT"
  }
}

resource "aws_eip" "eip" {
  depends_on = [aws_internet_gateway.igw]
  vpc        = true
}
