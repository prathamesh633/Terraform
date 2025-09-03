variable "vpc_cidr" {
  default = "10.0.0.0/16"
}
variable "vpc-tag" {
  default = "demo"
}
variable "public_subnet_cidr" {
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.4.0/24"]
}
variable "private_subnet_cidr" {
  default = ["10.0.3.0/24", "10.0.8.0/24", "10.0.11.0/24"]
}


variable "ami" {
  default = "ami-02d26659fd82cf299"
}
variable "instance_type" {
  default = "t2.micro"
}
variable "key_name" {
  default = "new-key"
}
variable "ec2-tag" {
  default = "demo-server"
}
variable "public_ip" {
  default = true
}


# variable "group_name" {
#   default = "demo-grp"
# }
# variable "given_user" {
#   default = ["user1", "user2"]
# }
# variable "policy_names" {
#   default = ["AmazonEC2FullAccess", "AmazonS3FullAccess"]
# }

# variable "eks-tag" {
#   default = "demo-cluster"
# }