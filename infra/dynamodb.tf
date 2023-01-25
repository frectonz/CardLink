# DaynamoDB Table
resource "aws_dynamodb_table" "card_link_table" {
  name           = var.links_table_name
  hash_key       = "link_id"
  range_key      = "user_id"
  read_capacity  = 1
  write_capacity = 1

  attribute {
    name = "link_id"
    type = "S"
  }

  attribute {
    name = "user_id"
    type = "S"
  }
}
