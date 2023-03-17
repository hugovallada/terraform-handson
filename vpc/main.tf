terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.58.0"
    }
  }

  backend "s3" {
    bucket = "hugolopes-terraform-state"
    key    = "project/vpc-chat/terraform.tfstate"
    region = "sa-east-1"
  }
}

provider "aws" {
  region = "sa-east-1"
  default_tags {
    tags = {
      ManagedBy = "Terraform"
      CreatedBy = "Hugo Lopes"
      Email     = "hugo.lopes@gmail.com"
    }
  }
}