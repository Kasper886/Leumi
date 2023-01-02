resource "aws_vpc" "test-spoke-vpc" {
  cidr_block = var.aws_vpc_cidr
  tags            = {
    Name          = "test-spoke-vpc"
  }
}

# Create public subnet
resource "aws_subnet" "public" {
  cidr_block              = var.aws_vpc_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  vpc_id                  = aws_vpc.test-spoke-vpc.id
  map_public_ip_on_launch = true

  tags = {
    Name = "PublicSubNet"
  }
}

# Internet Gateway for the public subnet
resource "aws_internet_gateway" "test-spoke-igw" {
  vpc_id = aws_vpc.test-spoke-vpc.id

   tags = {
     Name = "TestSpokeGW"
  }
}

# Route the public subnet traffic through the IGW
resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.test-spoke-vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.test-spoke-igw.id
}

# Associate the public subnet traffic and close private subnets traffic
resource "aws_route_table_association" "public-a" {
    subnet_id      = aws_subnet.public.id
    route_table_id = aws_vpc.test-spoke-vpc.main_route_table_id
}

# Allocate Elastic IPs
resource "aws_eip" "test-spoke-eip" {
  instance   = aws_instance.my_webserver.id
  vpc        = true
  depends_on = [aws_instance.my_webserver]
  
  tags = {
    Name     = "Test-Spoke-EIP"
    Owner    = "Alex Largman"
  }
}