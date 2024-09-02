terraform {
  backend "s3" {
    bucket         = "tooba-bucket"
    key            = "terraform.tfstate"
    region         = "us-west-1"
    dynamodb_table = "terraform_lock_table" 
    encrypt        = true
  }
  }