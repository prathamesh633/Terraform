terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.85.0"
    }
  }
}

# added the access and secret keys in profile
# command - 'aws configure' --> give the keys and mention the region
provider "aws"{
  profile = "terraform-user"
  region = "ap-south-1"
}

# terraform {
#   backend "s3" {
#     bucket  = "prathameshs3buckethh-1"
#     key     = "terraform/tfstate/terraform.tfstate"
#     region  = "ap-south-1"
#     profile = "user"
#   }
# }