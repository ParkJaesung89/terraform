terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

# backend 구성을 위해 "terraform init" 해야되며, terraform init 시에 아래 backend 설정은 주석처리해두고 진행해야됨.
  #backend s3 {
  #  bucket          = "jsp-tfstate"
  #  key             = "terraform/terraform.tfstate"
  #  region          = "ap-northeast-2"
  #  profile         = "jaesung.park"                # backend 구성시 추가로 프로파일의 이름을 정의해줘야됨.
  #  dynamodb_table  = "terraform-lock"
  #}

}


provider "aws" {
  region  = var.region
  shared_config_files      = ["~/.aws/config"]
  shared_credentials_files = ["~/.aws/credentials"]
  profile = "jaesung.park"
}
