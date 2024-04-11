# 아래는 backend를 설정 적용전에 미리 s3와 dynamodb 리소스 입니다.
# # backend 사용시에는 우선 해당 s3와 dynamodb 리소스가 생성되어 있어야됩니다.

# # Create s3 to store tfstate file
# resource "aws_s3_bucket" "terraform_tfstate" {
#  bucket        = "jsp-tfstate"
#  force_destroy = true      #false

#  # 리소스 삭제시에 테라폼 오류 및 종료됨
#  lifecycle {
#    prevent_destroy = false    #true
#  }
# }

# # S3 버킷에서 버전 관리를 제어하기 위한 리소스
# resource "aws_s3_bucket_versioning" "versioning_tfstate" {
#  bucket = aws_s3_bucket.terraform_tfstate.id
#  versioning_configuration {
#    status = "Enabled"          # Prevent from deleting tfstate file
#  }
# }

# # S3 버킷에 기록된 모든 데이터에 서버 측 암호화를 설정
# resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_tfstate_encryption" {
#  bucket = aws_s3_bucket.terraform_tfstate.id

#  rule {
#    apply_server_side_encryption_by_default {
#      sse_algorithm = "AES256"
#    }
#  }
# }

# resource "aws_s3_bucket_public_access_block" "terraform_tfstate_public_access_block" {
#  bucket = aws_s3_bucket.terraform_tfstate.id
#  block_public_acls       = true
#  block_public_policy     = true
#  ignore_public_acls      = true
#  restrict_public_buckets = true
# }

# #DynamoDB for terraform state lock
# resource "aws_dynamodb_table" "terraform_lock" {
#    name            = "terraform-lock"
#    hash_key        = "LockID"
#    billing_mode    = "PAY_PER_REQUEST"

#    attribute {
#        name        = "LockID"
#        type        = "S"
#    }
# }
