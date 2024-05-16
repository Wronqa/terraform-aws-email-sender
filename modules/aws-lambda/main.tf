locals {
  lambda_role       = file("${path.module}/policies/lambda-role.json")
  lambda_ses_policy = file("${path.module}/policies/lambda-ses-policy.json")

  s3_reader_dir           = "${path.module}/src/s3-reader-lambda/"
  s3_reader_zip           = "${path.module}/dist/s3-reader.zip"
  s3_reader_access_policy = file("${path.module}/policies/s3-reader-lambda-policy.json")

  email_verification_dir = "${path.module}/src/email-verification/"
  email_verification_zip = "${path.module}/dist/email-verification.zip"

  email_send_dir = "${path.module}/src/email-send/"
  email_send_zip = "${path.module}/dist/email-send.zip"

}

provider "archive" {
}

data "archive_file" "s3_reader_lambda_zip" {
  type        = "zip"
  source_dir  = local.s3_reader_dir
  output_path = local.s3_reader_zip
}

data "archive_file" "email_verification_lambda_zip" {
  type        = "zip"
  source_dir  = local.email_verification_dir
  output_path = local.email_verification_zip
}

data "archive_file" "email_send_lambda_zip" {
  type        = "zip"
  source_dir  = local.email_send_dir
  output_path = local.email_send_zip
}

#S3 Reader lambda

resource "aws_iam_policy" "s3_reader_access_policy" {
  name        = "s3_reader_access_policy"
  description = "Policy that allows lambda to get items from S3 bucket"
  policy      = local.s3_reader_access_policy
}

resource "aws_iam_role" "s3_reader_lambda_role" {
  name               = "s3_reader_lambda_role"
  assume_role_policy = local.lambda_role
}

resource "aws_iam_role_policy_attachment" "s3_access_policy_role_attachment" {
  role       = aws_iam_role.s3_reader_lambda_role.name
  policy_arn = aws_iam_policy.s3_reader_access_policy.arn
}
resource "aws_lambda_function" "s3_reader" {
  filename      = data.archive_file.s3_reader_lambda_zip.output_path
  function_name = "s3_reader"
  handler       = "main.lambda_handler"
  runtime       = "python3.12"
  memory_size   = 1024
  timeout       = 900
  role          = aws_iam_role.s3_reader_lambda_role.arn
  environment {
    variables = {
      state_machine_arn = var.state_machine_arn
      sender_email      = var.sender_email
    }
  }
}

#Email verification lambda

resource "aws_iam_policy" "lambda_ses_policy" {
  name        = "email_verification_ses_policy"
  description = "Policy that allows lambda to access to SES"
  policy      = local.lambda_ses_policy
}

resource "aws_iam_role" "lambda_ses_role" {
  name               = "lambda_ses_role"
  assume_role_policy = local.lambda_role
}
resource "aws_iam_role_policy_attachment" "lambda_ses_policy_role_attachment" {
  role       = aws_iam_role.lambda_ses_role.name
  policy_arn = aws_iam_policy.lambda_ses_policy.arn
}
resource "aws_lambda_function" "email_verification" {
  filename      = data.archive_file.email_verification_lambda_zip.output_path
  function_name = "email_verification"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"
  memory_size   = 1024
  timeout       = 900
  role          = aws_iam_role.lambda_ses_role.arn

  environment {
    variables = {
      aws_region = var.aws_region
    }
  }
}


#Email send lambda

resource "aws_lambda_function" "email_send" {
  filename      = data.archive_file.email_send_lambda_zip.output_path
  function_name = "email_send"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"
  memory_size   = 1024
  timeout       = 900
  role          = aws_iam_role.lambda_ses_role.arn

  environment {
    variables = {
      aws_region = var.aws_region
    }
  }
}
