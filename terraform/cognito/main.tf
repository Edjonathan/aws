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

resource "aws_cognito_user_pool" "pool" {
  name                = "demo-cognito-userpool"
  username_attributes = ["email"]

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
    recovery_mechanism {
      name     = "verified_phone_number"
      priority = 2
    }
  }
}

resource "aws_cognito_user_pool_client" "client" {
  name = "client"

  user_pool_id                  = aws_cognito_user_pool.pool.id
  generate_secret               = true
  explicit_auth_flows           = ["ALLOW_CUSTOM_AUTH", "ALLOW_USER_SRP_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]
  prevent_user_existence_errors = "ENABLED"
  enable_token_revocation       = true
  callback_urls                        = ["https://example.com"]
  supported_identity_providers         = ["COGNITO"]
  allowed_oauth_flows                  = ["code", "implicit"]
  allowed_oauth_scopes                 = ["phone","email", "openid","profile","aws.cognito.signin.user.admin"]
}

resource "aws_cognito_user_pool_domain" "domain" {
  domain          = "edjonathan-domain"
  user_pool_id    = aws_cognito_user_pool.pool.id
}