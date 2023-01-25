variable "user_pool_name" {
  type        = string
  description = "The name of the user pool"
  default     = "card-link-user-pool"
}

variable "user_pool_client_name" {
  type        = string
  description = "The name of the user pool client"
  default     = "card-link-user-pool-client"
}

variable "callback_urls" {
  type        = list(string)
  description = "The callback URLs"
  default     = ["https://example.com/callback"]
}

variable "logout_urls" {
  type        = list(string)
  description = "The logout URLs"
  default     = ["https://example.com/logout"]
}

variable "user_pool_domain" {
  type        = string
  description = "The domain of the user pool"
  default     = "card-link"
}

variable "links_table_name" {
  type        = string
  description = "The name of the links table"
  default     = "card-link-links-table"
}

variable "function_s3_bucket" {
  type        = string
  description = "The name of the S3 bucket where the Lambda function is stored"
  default     = "cardlink-create-link-function"
}

variable "create_link_s3_key" {
  type        = string
  description = "The key of the S3 object where the Lambda function is stored"
  default     = "v0.1.0/bootstrap.zip"
}

variable "api_cognito_authorizer_name" {
  type        = string
  description = "The name of the API authorizer"
  default     = "cardlink-api-cognito-authorizer"
}
