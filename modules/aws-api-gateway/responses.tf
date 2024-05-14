resource "aws_api_gateway_method_response" "put-200-response" {
  rest_api_id = aws_api_gateway_rest_api.aws_gateway_rest_api.id
  resource_id = aws_api_gateway_resource.Filename.id
  http_method = aws_api_gateway_method.PutItem.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Content-Disposition" = true
    "method.response.header.Content-Length"      = true
  }
}

resource "aws_api_gateway_method_response" "put-400-response" {
  depends_on  = [aws_api_gateway_integration.S3_integration_put]
  rest_api_id = aws_api_gateway_rest_api.aws_gateway_rest_api.id
  resource_id = aws_api_gateway_resource.Filename.id
  http_method = aws_api_gateway_method.PutItem.http_method
  status_code = "400"
}

resource "aws_api_gateway_method_response" "put-500-response" {
  depends_on  = [aws_api_gateway_integration.S3_integration_put]
  rest_api_id = aws_api_gateway_rest_api.aws_gateway_rest_api.id
  resource_id = aws_api_gateway_resource.Filename.id
  http_method = aws_api_gateway_method.PutItem.http_method
  status_code = "500"
}

resource "aws_api_gateway_integration_response" "put-200-integration" {
  depends_on = [aws_api_gateway_integration.S3_integration_put]

  rest_api_id = aws_api_gateway_rest_api.aws_gateway_rest_api.id
  resource_id = aws_api_gateway_resource.Filename.id
  http_method = aws_api_gateway_method.PutItem.http_method
  status_code = aws_api_gateway_method_response.put-200-response.status_code

  response_parameters = {
    "method.response.header.Content-Disposition" = "integration.response.header.Content-Disposition"
    "method.response.header.Content-Length"      = "integration.response.header.Content-Length"
  }
}

resource "aws_api_gateway_integration_response" "put-400-integration" {
  depends_on = [aws_api_gateway_integration.S3_integration_put]

  rest_api_id = aws_api_gateway_rest_api.aws_gateway_rest_api.id
  resource_id = aws_api_gateway_resource.Filename.id
  http_method = aws_api_gateway_method.PutItem.http_method
  status_code = aws_api_gateway_method_response.put-400-response.status_code

  selection_pattern = "4\\d{2}"
}

resource "aws_api_gateway_integration_response" "put-500-integration" {
  depends_on = [aws_api_gateway_integration.S3_integration_put]

  rest_api_id = aws_api_gateway_rest_api.aws_gateway_rest_api.id
  resource_id = aws_api_gateway_resource.Filename.id
  http_method = aws_api_gateway_method.PutItem.http_method
  status_code = aws_api_gateway_method_response.put-500-response.status_code

  selection_pattern = "5\\d{2}"
}
