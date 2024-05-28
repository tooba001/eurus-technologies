terraform {
  backend "s3" {
    bucket         = "tooba-state-bucket"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform_lock_table" 
    encrypt        = true
  }
  }

