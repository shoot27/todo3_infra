#個人
myip = ["113.42.231.254/32"]

# VPC
vpc_name = "vpc-todo-tajime"

#サブネット
snet_public_name = "snet-public-tajime"
snet_private_name = "snet-private-tajime"
availability_zone = "ap-northeast-1"

#インターネットゲートウェイ
igw_name = "igw-todo-tajime"

# NATゲートウェイ
eip_id = "eipalloc-0e263daf8f45d1b16"
ngw_name = "ngw-todo-tajime"

# ルートテーブル
rt_public_name = "rt-public-tajime"
rt_private_name = "rt-private-tajime"

#セキュリティグループ
sg_public_name = "sg-public-tajime"
sg_private_name = "sg-private-tajime"

#EC2
ami = "ami-0eba6c58b7918d3a1"
instance_type = "t2.micro"
key_name = "key-kensho-tajime"
ec2_web_name = "vm-todo-web-tajime"
ec2_app_name = "vm-todo-app-tajime"