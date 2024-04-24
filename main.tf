# Create a VPC
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "vpc-todo-tajime"
  }
}

# サブネットをVPC内に作成
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.10.0/24"
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "snet-public-tajime"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.20.0/24"
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "snet-private-tajime"
  }
}

# インターネットゲートウェイを作成
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "igw-todo-tajime"
  }
}

# NATゲートウェイを作成
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = "eipalloc-0e263daf8f45d1b16"
  subnet_id     = aws_subnet.public_subnet.id
  tags = {
    Name = "ngw-todo-tajime"
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
    Name = "rt-public-tajime"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway.id
  }
  tags = {
    Name = "rt-private-tajime"
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

# セキュリティグループを作成し、SSHとHTTPをすべての範囲で許可
resource "aws_security_group" "public_sg" {
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["113.42.231.254/32"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["113.42.231.254/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "sg-public-tajime"
  }
}

# セキュリティグループを作成し、SSHとHTTPをすべての範囲で許可
resource "aws_security_group" "private_sg" {
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.public_sg.id]
  }

    ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    security_groups = [aws_security_group.public_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "sg-private-tajime"
  }
}

# EC2インスタンス(Webサーバー)を作成
resource "aws_instance" "web_instance" {
  ami           = "ami-0eba6c58b7918d3a1"
  instance_type = "t2.micro"
  key_name      = "key-kensho-tajime"

  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.public_sg.id]
  associate_public_ip_address = true
  tags = {
    Name = "vm-todo-web-tajime"
  }
}

# EC2インスタンス(アプリケーションサーバー)を作成
resource "aws_instance" "app_instance" {
  ami           = "ami-0eba6c58b7918d3a1"
  instance_type = "t2.micro"
  key_name      = "key-kensho-tajime"

  subnet_id              = aws_subnet.private_subnet.id
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  associate_public_ip_address = false
  tags = {
    Name = "vm-todo-app-tajime"
  }
}

