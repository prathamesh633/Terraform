module "VPC" {
  source              = "./VPC-code"
  tag                 = var.vpc-tag
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
}

module "EC2" {
  source        = "./EC2-code"
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name
  tags          = var.ec2-tag
  public_ip     = var.public_ip
  subnet_id     = module.VPC.public_subnet_id[0] // this will choose the first public subnet range defined in the var.rf file.
  vpc_id        = module.VPC.vpc_id              // this is for vpc id as it is not deined till the vpc is created.
  security_group = [module.EC2.security_group_id] // this is in brackets because the security-group-ids from vpc will be in list.
  ingress_ports = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

# module "S3" {
#   source     = "./S3-code"
#   count      = 5
#   bucketname = "prathameshs3buckethh-${count.index + 1}"
# }

module "S3" {
  source     = "./S3-code"
  bucketname = "prathameshnews3bucket"
}

# module "IAM" {
#   source = "./IAM-code"
#   group_name = var.group_name
#   given_user = var.given_user
#   policy_names = var.policy_names
# }

# module "eks" {
#   source               = "./eks"
#   cluster_name         = "${var.eks-tag}-deploy-cluster"
#   subnet_ids           = module.VPC.private_subnet_id
#   instance_type        = "t2.medium"
#   desired_size         = 2
#   max_size             = 5
#   min_size             = 1
# }

module "RDS" {
  source = "./RDS"
  engine = "mysql"
  engine-version = "8.0"
  rds-type =  "db.t3.micro"
  username = "admin"
  password = "Redhat123"
  parameter-group-name = "default.mysql8.0"
  security-group-ids = [module.EC2.security_group_id]
  subnet_ids = module.VPC.private_subnet_id
  rds-name = "demo-RDS"
}