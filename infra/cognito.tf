resource "aws_cognito_user_pool" "card_link_user_pool" {
  name                     = var.user_pool_name
  auto_verified_attributes = ["email"]

  schema {
    name                     = "email"
    required                 = true
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    string_attribute_constraints {
      min_length = 0
      max_length = 2048
    }
  }

  password_policy {
    minimum_length    = 6
    require_lowercase = false
    require_numbers   = false
    require_symbols   = false
    require_uppercase = false
  }
}

resource "aws_cognito_user_pool_client" "card_link_user_client" {
  name                                 = var.user_pool_client_name
  user_pool_id                         = aws_cognito_user_pool.card_link_user_pool.id
  callback_urls                        = var.callback_urls
  logout_urls                          = var.logout_urls
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code", "implicit"]
  allowed_oauth_scopes                 = ["phone", "email", "openid", "profile", "aws.cognito.signin.user.admin"]
  supported_identity_providers         = ["COGNITO"]
}

resource "aws_cognito_user_pool_domain" "card_link_user_pool_domain" {
  domain       = var.user_pool_domain
  user_pool_id = aws_cognito_user_pool.card_link_user_pool.id
}
