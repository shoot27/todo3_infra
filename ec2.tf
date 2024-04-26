# セキュリティグループを作成し、SSHとHTTPをすべての範囲で許可
resource "aws_security_group" "public_sg" {
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.myip
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.myip
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = var.sg_public_name
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
    Name = var.sg_private_name
  }
}

# EC2インスタンス(Webサーバー)を作成
resource "aws_instance" "web_instance" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name

  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.public_sg.id]
  associate_public_ip_address = true
  tags = {
    Name = var.ec2_web_name
  }
}

# EC2インスタンス(アプリケーションサーバー)を作成
resource "aws_instance" "app_instance" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name

  subnet_id              = aws_subnet.private_subnet.id
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  associate_public_ip_address = false
  tags = {
    Name = var.ec2_app_name
  }
}