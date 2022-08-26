resource "aws_vpc" "another_vpc" {
  tags = {
    Name="my_vpc"
  }
  cidr_block = var.vpc_cidr
  
}
##Create a public subnet
resource "aws_subnet" "test_public_subnet" {
  vpc_id = aws_vpc.another_vpc.id
  availability_zone=data.aws_availability_zones.available.names[0]
}

##Create a PublicRoute table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.another_vpc.id

}

## Create a Internet gateway
resource "aws_internet_gateway" "gt" {
  vpc_id = aws_vpc.another_vpc.id

  tags = {
    Name = "main_gt"
  }
}

## Associate route table to subnet
resource "aws_route_table_association" "rt_assoc" {
  subnet_id      = aws_subnet.test_public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}


## Create a Route for the subnet
resource "aws_route" "default_route_test" {
  route_table_id = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.gt.id
}
## Create security groups
resource "aws_security_group" "up_sg_22" {
  name = "up_sg_22"
  vpc_id = aws_vpc.another_vpc.id

  # SSH access from the VPC
  ingress {
      from_port     = 22
      to_port       = 22
      protocol      = "tcp"
      cidr_blocks   = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Environment     = "my_RS_group"
  }
}