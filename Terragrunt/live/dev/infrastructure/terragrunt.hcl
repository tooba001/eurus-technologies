# Terragrunt configuration to first create an S3 bucket, store values, and then use those values in Lambda

terraform {
  source = "/home/thinkpad/Terragrunt/modules/lambda"   
}

inputs = {
  bucket = "dev-lambda-s3-bucket-tooba-abc"
  function_name = "lambda-function-tooba-abc"
  handler       = "index.handler"
  runtime       = "python3.9"
  region        = "us-west-1"
  source_path   = "/home/thinkpad/lambda/lambda-package.zip"
}



