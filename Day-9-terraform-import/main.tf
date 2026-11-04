provider "aws" {
  region = "us-east-1"
}

# EC2 Instance
resource "aws_instance" "name" {
  ami           = "ami-0d27e0fb3bac4d724"
  instance_type = "t2.medium"

  tags = {
    Name = "Manoj-terraform-instance"
  }
}

# S3 Bucket
resource "aws_s3_bucket" "dev" {
  bucket = "dev-test-prod-bkt-manoj"
}

# Enable S3 Bucket Versioning
resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.dev.id

  versioning_configuration {
    status = "Enabled"
  }
}