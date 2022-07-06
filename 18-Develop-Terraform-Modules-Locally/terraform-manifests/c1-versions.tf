# Terraform Block
terraform {
  required_version = "1.2.2" # which means any version equal & above 0.14 like 0.15, 0.16 etc and < 1.xx
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Provider Block
provider "aws" {
  region  = var.aws_region
  profile = "default"
}
/*
Note-1:  AWS Credentials Profile (profile = "default") configured on your local desktop terminal  
$HOME/.aws/credentials
*/
#Uses of modules:
#1 Direct ga terraform website lo module ni use chestam code execute chesinappuudu adhi direct ga ah site lo vunna module ni load chestadi - mostly used
#2 local module antey terraform site lo module ni zip file download chesi module folder lo petti execute chestey -
# local lo vunna terraform module folder nundi module load ayyi script execute avutadi
#3 create resources on normal terraform files and create module from the existing resources files.