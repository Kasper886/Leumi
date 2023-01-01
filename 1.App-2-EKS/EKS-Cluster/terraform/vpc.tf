# network.tf

resource "aws_vpc" "wave-vpc" {
  cidr_block = var.aws_vpc_cidr
  tags            = {
    Name          = "wave-vpc"
  }
}

# Fetch AZs in the current region
data "aws_availability_zones" "available" {
}


# Create var.az_count private subnets, each in a different AZ
resource "aws_subnet" "private" {
  count                   = var.az_count
  cidr_block              = cidrsubnet(aws_vpc.wave-vpc.cidr_block, 8, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  vpc_id                  = aws_vpc.wave-vpc.id
  map_public_ip_on_launch = false

  tags = {
    Name                        = "PrivateSubnet-${count.index+1}"
    "kubernetes.io/cluster/eks" = "shared"
    "kubernetes.io/role/elb"    = 1
    Owner                       = "Alex Largman"
  }
}

# Create public subnet
resource "aws_subnet" "public" {
  count                   = var.az_count
  cidr_block              = cidrsubnet(aws_vpc.wave-vpc.cidr_block, 8, count.index+2)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  vpc_id                  = aws_vpc.wave-vpc.id
  map_public_ip_on_launch = true

  tags = {
    Name = "PublicSubNet-${count.index+1}"
    "kubernetes.io/cluster/eks" = "shared"
    "kubernetes.io/role/elb"    = 1
    Owner                       = "Alex Largman"
  }
}

# Internet Gateway for the public subnet
resource "aws_internet_gateway" "wave-igw" {
  vpc_id = aws_vpc.wave-vpc.id

   tags = {
     Name = "WaveGW"
  }
}

# Route the public subnet traffic through the IGW
resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.wave-vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.wave-igw.id
}

# Associate the public subnet traffic and close private subnets traffic
resource "aws_route_table_association" "public" {
    count          = var.az_count
    subnet_id      = element(aws_subnet.public.*.id, count.index)
    route_table_id = aws_vpc.wave-vpc.main_route_table_id
}


# Private networks A and B with NAT GW to enable to install soft
# You can delete NGWs and route tables after settings

# Allocate 2 Elastic IPs for 2 NGW
resource "aws_eip" "wave-eip" {
  count      = var.az_count
  vpc        = true
  depends_on = [aws_internet_gateway.wave-igw]
  
  tags = {
    Name     = "Wave-EIP-${count.index+1}"
  }
}

# Ceate 2 Nat GW
resource "aws_nat_gateway" "wave-natgw" {
  count         = var.az_count
  subnet_id     = aws_subnet.public.0.id
  allocation_id = element(aws_eip.wave-eip.*.id, count.index)
  
  tags = {
    Name        = "Wave-NGW-${count.index+1}"
  }
}


# Create a new route table for the private subnets, make it route non-local traffic through the NAT gateway to the internet
resource "aws_route_table" "private" {
  count  = var.az_count
  vpc_id = aws_vpc.wave-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.wave-natgw.*.id, count.index)
  }

  tags = {
     Name          = "WaveNGW-${count.index+1}"
  }
}

# Explicitly associate the newly created route tables to the private subnets (so they don't default to the main route table)
resource "aws_route_table_association" "private" {
  count          = var.az_count
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}