terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  
  #backend "s3" {
  #  bucket         = "jsp-s3"
  #  key            = "terraform/terraform.tfstate"
  #  region         = "ap-northeast-2"
  #  encrypt        = true
  #  dynamodb_table = "terraform-tfstate-lock"
  #}
}
