resource "aws_api_gateway_rest_api" "cardlink_api" {
  name        = "cardlink-api"
  description = "API for CardLink"
}

resource "aws_api_gateway_resource" "link_proxy" {
  rest_api_id = aws_api_gateway_rest_api.cardlink_api.id
  parent_id   = aws_api_gateway_rest_api.cardlink_api.root_resource_id
  path_part   = "link"
}

resource "aws_api_gateway_method" "link_proxy" {
  rest_api_id = aws_api_gateway_rest_api.cardlink_api.id
  resource_id = aws_api_gateway_resource.link_proxy.id
  http_method = "POST"

  authorization        = "COGNITO_USER_POOLS"
  authorizer_id        = aws_api_gateway_authorizer.cardlink_api.id
  authorization_scopes = ["aws.cognito.signin.user.admin"] // ["email", "openid", "profile"]
}

resource "aws_api_gateway_integration" "create_link" {
  rest_api_id = aws_api_gateway_rest_api.cardlink_api.id
  resource_id = aws_api_gateway_resource.link_proxy.id
  http_method = aws_api_gateway_method.link_proxy.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.create_link.invoke_arn
}

resource "aws_api_gateway_deployment" "cardlink_api" {
  depends_on  = [aws_api_gateway_integration.create_link]
  rest_api_id = aws_api_gateway_rest_api.cardlink_api.id
  stage_name  = "prod"
}

resource "aws_api_gateway_authorizer" "cardlink_api" {
  name          = var.api_cognito_authorizer_name
  rest_api_id   = aws_api_gateway_rest_api.cardlink_api.id
  type          = "COGNITO_USER_POOLS"
  provider_arns = [aws_cognito_user_pool.card_link_user_pool.arn]
}
