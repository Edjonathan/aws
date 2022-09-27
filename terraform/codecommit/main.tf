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
  region = var.aws_region
  #Not Recommended
  #access_key =
  ##secret_key = 
  profile = var.aws_profile
}

resource "aws_codecommit_repository" "this" {
  repository_name = "my-repo-teste"
  description     = "Meu repositorio teste"
}