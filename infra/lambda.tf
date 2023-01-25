resource "aws_iam_role" "lambda_exec" {
  name = "cardlink-lambda-exec-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "create_link" {
  function_name = "cardlink-create-link-function"

  s3_bucket = var.function_s3_bucket
  s3_key    = var.create_link_s3_key

  handler = "bootstrap"
  runtime = "provided.al2"

  architectures = ["arm64"]

  role = aws_iam_role.lambda_exec.arn
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.create_link.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.cardlink_api.execution_arn}/*/*"
}
