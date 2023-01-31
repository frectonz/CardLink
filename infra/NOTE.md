# Note

## Weird Issue

Connection_type error on aws_api_gateway_integration

```text
PR: <https://github.com/hashicorp/terraform-provider-aws/pull/29016>
ISSUE: <https://github.com/hashicorp/terraform-provider-aws/issues/28997>
```

------

## DO THE FOLLOWING BEFORE RUNNING TERRAFORM

<https://developer.hashicorp.com/terraform/language/settings/backends/s3>

Create the S3 bucket for terraform state

```sh
aws s3api create-bucket --bucket=cardlink-terraform --region=us-east-1
```

Create the DynamoDB table for terraform state

```sh
aws dynamodb create-table --table-name=cardlink-terraform --attribute-definitions=AttributeName=LockID,AttributeType=S --key-schema=AttributeName=LockID,KeyType=HASH --billing-mode=PAY_PER_REQUEST
```
