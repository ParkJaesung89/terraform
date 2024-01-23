# 아래는 backend를 설정 적용전에 미리 s3와 dynamodb 리소스 입니다.
# backend 사용시에는 우선 해당 s3와 dynamodb 리소스가 생성되어 있어야됩니다.

## Create s3 to store tfstate file
#resource "aws_s3_bucket" "terraform_tfstate" {
#  bucket        = "jsp-tfstate"
#  force_destroy = true      #false
#}

#resource "aws_s3_bucket_versioning" "versioning_tfstate" {
#  bucket = aws_s3_bucket.terraform_tfstate.id
#  versioning_configuration {
#    status = "Enabled"          # Prevent from deleting tfstate file
#  }
#}


## DynamoDB for terraform state lock
#resource "aws_dynamodb_table" "terraform_lock" {
#    name            = "terraform-lock"
#    hash_key        = "LockID"
#    billing_mode    = "PAY_PER_REQUEST"
#
#    attribute {
#        name        = "LockID"
#        type        = "S"
#    }
#}