# Created Bucket demo-object-storage
resource "aws_s3_bucket" "demo-storage" {
    bucket = "demo-storage"
  tags = {
    Enviroment: "demo"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "bucket-config-demo-storage" {
  bucket = aws_s3_bucket.demo-storage.id

  rule {
    id = "archive"
    status = "Enabled"
    transition {
      days          = 365
      storage_class = "GLACIER"
    }
  }
}
resource "aws_s3_bucket_acl" "bucket-acl-demo-storage" {
  bucket = aws_s3_bucket.demo-storage.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "versioning-demo-storage" {
  bucket = aws_s3_bucket.demo-storage.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_metric" "enable-metrics-bucket" {
  bucket = aws_s3_bucket.demo-storage.id
  name   = "EntireBucket"
}

