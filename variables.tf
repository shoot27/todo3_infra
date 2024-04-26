#個人
variable myip {}

# VPC
variable vpc_name {}

#サブネット
variable snet_public_name {}
variable snet_private_name {}
variable availability_zone {}

#インターネットゲートウェイ
variable igw_name {}

# NATゲートウェイ
variable eip_id {}
variable ngw_name {}

# ルートテーブル
variable rt_public_name {}
variable rt_private_name {}

#セキュリティグループ
variable sg_public_name {}
variable sg_private_name {}

#EC2
variable ami {}
variable instance_type {}
variable key_name {}
variable ec2_web_name {}
variable ec2_app_name {}