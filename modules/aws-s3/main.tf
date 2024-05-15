resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_notification" "s3_lambda_trigger" {
  bucket = aws_s3_bucket.s3_bucket.id
  lambda_function {
    lambda_function_arn = var.s3_reader_lambda.arn
    events              = ["s3:ObjectCreated:*"]
  }
}

resource "aws_lambda_permission" "s3_lambda_trigger_permission" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = var.s3_reader_lambda.name
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::${aws_s3_bucket.s3_bucket.id}"
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
