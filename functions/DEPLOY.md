# Instructions to Deploy the Functions to S3

## Build the functions

```sh
cargo lambda build --release --arm64 --output-format zip
```

## Create a new S3 bucket

```sh
aws s3api create-bucket --bucket cardlink-functions
```

## Copy the `bootstrap.zip` file to the S3 bucket

```sh
aws s3 cp target/lambda/{function_name}/bootstrap.zip s3://cardlink-functions/{function_name}.zip
```
