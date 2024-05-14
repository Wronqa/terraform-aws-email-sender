locals {
  s3_policy         = file("${path.module}/policies/s3-policy.json")
  apigateway_policy = file("${path.module}/policies/apigateway-policy.json")
}

resource "aws_iam_policy" "s3_policy" {
  name   = "s3-policy"
  policy = local.s3_policy
}

resource "aws_iam_role" "s3_api_gateyway_role" {
  name               = "s3-api-gateyway-role"
  assume_role_policy = file("${path.module}/policies/apigateway-policy.json")
}

resource "aws_iam_role_policy_attachment" "s3_policy_attach" {
  role       = aws_iam_role.s3_api_gateyway_role.name
  policy_arn = aws_iam_policy.s3_policy.arn
}

resource "aws_api_gateway_rest_api" "aws_gateway_rest_api" {
  name        = "aws_gateway_rest_api"
  description = "API for upload CSV files to S3"
}

resource "aws_api_gateway_resource" "Bucket" {
  rest_api_id = aws_api_gateway_rest_api.aws_gateway_rest_api.id
  parent_id   = aws_api_gateway_rest_api.aws_gateway_rest_api.root_resource_id
  path_part   = "{bucket}"
}

resource "aws_api_gateway_resource" "Filename" {
  rest_api_id = aws_api_gateway_rest_api.aws_gateway_rest_api.id
  parent_id   = aws_api_gateway_resource.Bucket.id
  path_part   = "{filename}"
}

resource "aws_api_gateway_method" "PutItem" {
  rest_api_id   = aws_api_gateway_rest_api.aws_gateway_rest_api.id
  resource_id   = aws_api_gateway_resource.Filename.id
  http_method   = "PUT"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.bucket"   = true
    "method.request.path.filename" = true
  }
}

resource "aws_api_gateway_integration" "S3_integration_put" {
  rest_api_id = aws_api_gateway_rest_api.aws_gateway_rest_api.id
  resource_id = aws_api_gateway_resource.Filename.id
  http_method = aws_api_gateway_method.PutItem.http_method

  integration_http_method = "PUT"

  request_parameters = {
    "integration.request.path.bucket"   = "method.request.path.bucket"
    "integration.request.path.filename" = "method.request.path.filename"
  }

  type = "AWS"

  uri         = "arn:aws:apigateway:${var.region}:s3:path/{bucket}/{filename}"
  credentials = aws_iam_role.s3_api_gateyway_role.arn
}

resource "aws_api_gateway_deployment" "ApiDeployment" {
  depends_on  = [aws_api_gateway_integration.S3_integration_put]
  rest_api_id = aws_api_gateway_rest_api.aws_gateway_rest_api.id
  stage_name  = "dev"
}
