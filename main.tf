provider "aws" {
  region = "us-east-2"
}
resource "aws_s3_bucket" "s3_tf" {
  bucket = "mytfstate-bk-webapp-dev"
  lifecycle {
    prevent_destroy = true
  }
}
resource "aws_s3_bucket_versioning" "version" {
  bucket = aws_s3_bucket.s3_tf.id
  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.s3_tf.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
resource "aws_s3_bucket_public_access_block" "public_acess" {
  bucket = aws_s3_bucket.s3_tf.id
  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}
resource "aws_dynamodb_table" "tflock" {
  name = "terraform"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}