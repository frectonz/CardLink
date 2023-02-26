output "user_pool_arn" {
  value = aws_cognito_user_pool.card_link_user_pool.arn
}

output "user_pool_client_id" {
  value = aws_cognito_user_pool_client.card_link_user_client.id
}

output "user_pool_domain" {
  value = aws_cognito_user_pool_domain.card_link_user_pool_domain.domain
}

output "links_table_name_arn" {
  value = aws_dynamodb_table.card_link_table.arn
}

output "create_link_function_arn" {
  value = aws_lambda_function.create_link.arn
}

output "api_gateway_url" {
  value = aws_api_gateway_rest_api.cardlink_api.execution_arn
}

output "api_gateway_id" {
  value = aws_api_gateway_rest_api.cardlink_api.id
}
