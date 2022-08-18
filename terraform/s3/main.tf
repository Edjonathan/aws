terraform {
  required_version = "1.2.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.18.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  #Not Recommended
  #access_key =
  ##secret_key = 
  profile = "terraform"
}

module "bucket" {
    source = "./module_bucket_cloudfront"
    bucket-name = "var.bucket-name"
}