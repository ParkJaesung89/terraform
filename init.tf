# S3 bucket for backend
resource "aws_s3_bucket" "jsp-s3" {
  bucket = "jsp-s3"
}

# Prevent from deleting tfstate file
resource "aws_s3_bucket_versioning" "jsp_s3_versioning" {
  bucket = aws_s3_bucket.jsp-s3.id

  versioning_configuration {
    status = "Enabled"
  }
}



# DynamoDB for terraform state lock
resource "aws_dynamodb_table" "terraform_tfstate_lock" {
  name         = "terraform-tfstate-lock"
  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }
}
