locals {
  s3_reader_dir           = "${path.module}/src/s3-reader-lambda/"
  s3_reader_zip           = "${path.module}/dist/s3-reader.zip"
  s3_reader_role          = file("${path.module}/policies/s3-reader-lambda-role.json")
  s3_reader_access_policy = file("${path.module}/policies/s3-reader-lambda-access-policy.json")
}

provider "archive" {
}

data "archive_file" "s3_reader_lambda_zip" {
  type        = "zip"
  source_dir  = local.s3_reader_dir
  output_path = local.s3_reader_zip
}

resource "aws_iam_policy" "s3_reader_access_policy" {
  name        = "s3_reader_access_policy"
  description = "Policy that allows lambda to get items from S3 bucket"
  policy      = local.s3_reader_access_policy
}

resource "aws_iam_role" "lambda_role" {
  name               = "lambda_role"
  assume_role_policy = local.s3_reader_role
}

resource "aws_iam_role_policy_attachment" "s3_access_policy_role_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.s3_reader_access_policy.arn
}

#S3 Reader lambda

resource "aws_lambda_function" "s3_reader" {
  filename      = data.archive_file.s3_reader_lambda_zip.output_path
  function_name = "s3_reader"
  handler       = "main.lambda_handler"
  runtime       = "python3.12"
  memory_size   = 1024
  timeout       = 900
  role          = aws_iam_role.lambda_role.arn
}
