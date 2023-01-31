# Instructions to Deploy the Functions to S3

## Create a new S3 bucket

```sh
aws s3api create-bucket --bucket=cardlink-{function_name}-function --region=us-east-1
```

**Sample:**

```sh
aws s3api create-bucket --bucket=cardlink-create-link-function --region=us-east-1
```

## Copy the `bootstrap.zip` file to the S3 bucket

```sh
aws s3 cp target/lambda/{function_name}/bootstrap.zip s3://cardlink-{function_name}-function/v{version_num}/bootstrap.zip
```

**Sample:**

```sh
aws s3 cp target/lambda/create-link/bootstrap.zip s3://cardlink-create-link-function/v0.1.0/bootstrap.zip
```
