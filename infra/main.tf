terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.50.0"
    }
  }


  backend "s3" {
    bucket         = "cardlink-terraform"
    key            = "network/terraform.tfstate"
    dynamodb_table = "cardlink-terraform"
    region         = "us-east-1"
  }
}

provider "aws" {}
