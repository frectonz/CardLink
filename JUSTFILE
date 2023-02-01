default:
  @just --choose

check:
  cd functions; cargo check

build:
  cd functions; cargo lambda build --release --arm64 --output-format zip

publish: build
  cd functions; aws s3 cp target/lambda/list-links/bootstrap.zip s3://cardlink-functions/list-links.zip
  cd functions; aws s3 cp target/lambda/create-link/bootstrap.zip s3://cardlink-functions/create-link.zip

create-functions-bucket:
  aws s3api create-bucket --bucket cardlink-functions

delete-functions-bucket:
  aws s3 rm s3://cardlink-functions --recursive

create-terraform-bucket:
  aws s3api create-bucket --bucket cardlink-terraform

delete-terraform-bucket:
  aws s3 rm s3://cardlink-terraform --recursive

create-terraform-dynamodb:
  aws dynamodb create-table \
    --table-name cardlink-terraform \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST

delete-terraform-dynamodb:
  aws dynamodb delete-table --table-name cardlink-terraform

apply-infra:
  cd infra; terraform apply

destroy-infra:
  cd infra; terraform destroy

setup-terraform: create-terraform-bucket create-terraform-dynamodb
destroy-terraform: delete-terraform-bucket delete-terraform-dynamodb

setup-functions: create-functions-bucket publish
destroy-functions: delete-functions-bucket

setup: setup-terraform setup-functions apply-infra
destroy: destroy-infra destroy-terraform destroy-functions