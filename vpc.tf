#VPCを作成
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = var.vpc_name
  }
}

# サブネットをVPC内に作成
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.10.0/24"
  availability_zone = var.availability_zone

  tags = {
    Name = var.snet_public_name
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.20.0/24"
  availability_zone = var.availability_zone

  tags = {
    Name = var.snet_private_name
  }
}

# インターネットゲートウェイを作成
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = var.igw_name
  }
}

# NATゲートウェイを作成
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = var.eip_id
  subnet_id     = aws_subnet.public_subnet.id
  tags = {
    Name = var.ngw_name
  }
}

# ルートテーブルを作成し、インターネットゲートウェイに向けたルートを設定
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = var.rt_public_name
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway.id
  }
  tags = {
    Name = var.rt_private_name
  }
}

# SubnetとRoute tableの関連付け
resource "aws_route_table_association" "my_public_rt_associate" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "my_private_rt_associate" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}