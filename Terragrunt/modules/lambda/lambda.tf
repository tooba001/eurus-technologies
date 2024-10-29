module "lambda_function" {
  source = "/home/thinkpad/Terragrunt/resources/lambda-resource"

  function_name = var.function_name
  handler       = var.handler
  runtime       = var.runtime
  region        = var.region
  source_path   = var.source_path
  
}

module "s3_bucket" {
  source = "/home/thinkpad/Terragrunt/resources/s3"

  bucket = var.bucket
}
 
