# Create a VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "vpc-test-tajime"
  }
}

# サブネットをVPC内に作成
resource "aws_subnet" "my_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.1.1.0/24"
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "snet-test-tajime"
  }
}

# インターネットゲートウェイを作成
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "igw-test-tajime"
  }
}

# ルートテーブルを作成し、インターネットゲートウェイに向けたルートを設定
resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }
  tags = {
    Name = "rt-test-tajime"
  }
}

# SubnetとRoute tableの関連付け
resource "aws_route_table_association" "my_public_rt_associate" {
  subnet_id      = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.my_route_table.id
}

# セキュリティグループを作成し、SSHとHTTPをすべての範囲で許可
resource "aws_security_group" "my_sg" {
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "sg-test-tajime"
  }
}

# EC2インスタンスを作成
resource "aws_instance" "my_instance" {
  ami           = "ami-0eba6c58b7918d3a1"
  instance_type = "t2.micro"
  key_name      = "key-kensho-tajime"

  subnet_id              = aws_subnet.my_subnet.id
  vpc_security_group_ids = [aws_security_group.my_sg.id]
  associate_public_ip_address = true
  tags = {
    Name = "vm-test-tajime"
  }
}

