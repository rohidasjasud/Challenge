#creat vpc
resource "aws_vpc" "demo-VPC" {
    cidr_block = var.vpc_cidr
    instance_tenancy = "default"
    enable_dns_hostnames = true

 tags = {
    Name = "demo-VPC"
    Environment = "dev"

 }
}

# creating IGW
resource "aws_internet_gateway" "demo-IGW" {
  vpc_id = aws_vpc.demo-VPC.id

  tags = {
    Name = "demo-IGW"
    Environment = "dev"
  }
}

#creating public subnet 1
resource "aws_subnet" "demo-PublicsubnetA" {
  vpc_id     = aws_vpc.demo-VPC.id
  cidr_block = var.public_subnet_cidr_1
  availability_zone = var.availability_zone_names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "demo-PublicsubnetA"
    Environment = "dev"
  }
}

#creating public subnet 2
resource "aws_subnet" "demo-PublicsubnetB" {
  vpc_id     = aws_vpc.demo-VPC.id
  cidr_block = var.public_subnet_cidr_2
  availability_zone = var.availability_zone_names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "demo-PublicsubnetB"
    Environment = "dev"
  }
}

#creating Route table and public subnets
resource "aws_route_table" "demo-Publicroutetable" {
  vpc_id = aws_vpc.demo-VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo-IGW.id
  }


  tags = {
    Name = "demo-Publicroutetable"
    Environment = "dev"
  }
}

#creating private subnet 1
resource "aws_subnet" "demo-PrivatesubnetA" {
  vpc_id     = aws_vpc.demo-VPC.id
  cidr_block = var.private_subnet_cidr_1
  availability_zone = var.availability_zone_names[0]
  map_public_ip_on_launch = false

  tags = {
    Name = "demo-PrivatesubnetA"
    Environment = "dev"
  }
}

#creating private subnet 2
resource "aws_subnet" "demo-PrivatesubnetB" {
  vpc_id     = aws_vpc.demo-VPC.id
  cidr_block = var.private_subnet_cidr_2
  availability_zone = var.availability_zone_names[1]
  map_public_ip_on_launch = false

  tags = {
    Name = "demo-PrivatesubnetB"
    Environment = "dev"
  }
}

#creating Route table for private subnets
resource "aws_route_table" "demo-Privateroutetable" {
  vpc_id = aws_vpc.demo-VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.demo-NAT-gateway.id
  }

  tags = {
    Name = "demo-Privateroutetable"
    Environment = "dev"
  }
}

# creating public subnet 1 association
resource "aws_route_table_association" "demo-PublicroutetableassociationA" {
  subnet_id      = aws_subnet.demo-PublicsubnetA.id
  route_table_id = aws_route_table.demo-Publicroutetable.id
}

# creating public subnet 2 association
resource "aws_route_table_association" "demo-PublicroutetableassociationB" {
  subnet_id      = aws_subnet.demo-PublicsubnetB.id
  route_table_id = aws_route_table.demo-Publicroutetable.id
}

# creating private subnet 1 association
resource "aws_route_table_association" "demo-PrivateroutetableassociationA" {
  subnet_id      = aws_subnet.demo-PrivatesubnetA.id
  route_table_id = aws_route_table.demo-Privateroutetable.id
}


# creating private subnet 2 association
resource "aws_route_table_association" "demo-PrivateroutetableassociationB" {
  subnet_id      = aws_subnet.demo-PrivatesubnetB.id
  route_table_id = aws_route_table.demo-Privateroutetable.id
}

# creating eip
resource "aws_eip" "demo-EIP" {
  vpc = true
  depends_on = [aws_internet_gateway.demo-IGW]

  tags = {
    Name = "demo-EIP"
  }
}

# Create NAT gateway for Private Instances
resource "aws_nat_gateway" "demo-NAT-gateway" {
  allocation_id = aws_eip.demo-EIP.id
  subnet_id     = aws_subnet.demo-PublicsubnetA.id

  tags = {
    Name = "demo-NAT-gateway"
  }

  depends_on = [aws_internet_gateway.demo-IGW]
}



#creating security groups

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.demo-VPC.id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}
