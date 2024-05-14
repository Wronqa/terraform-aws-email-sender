resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_public_access_block" "bucket_public_access" {
  bucket = aws_s3_bucket.s3_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket     = aws_s3_bucket.s3_bucket.id
  acl        = "public-read"
  depends_on = [aws_s3_bucket_ownership_controls.bucket_acl_ownership]
}

resource "aws_s3_bucket_ownership_controls" "bucket_acl_ownership" {
  bucket = aws_s3_bucket.s3_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
  depends_on = [aws_s3_bucket_public_access_block.bucket_public_access]
}


resource "aws_s3_bucket_policy" "csv_only_policy" {
  bucket     = aws_s3_bucket.s3_bucket.id
  policy     = data.aws_iam_policy_document.allow_only_csv_files.json
  depends_on = [aws_s3_bucket_public_access_block.bucket_public_access]
}

data "aws_iam_policy_document" "allow_only_csv_files" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    effect = "Deny"

    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl"
    ]
    not_resources = ["${aws_s3_bucket.s3_bucket.arn}/*.csv"]
  }
  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.s3_bucket.arn}/*"]
  }
}
