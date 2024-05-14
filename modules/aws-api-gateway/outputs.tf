output "api_gateway_deployment_invoke_url" {
  description = "Url to upload files into S3"
  value       = aws_api_gateway_deployment.ApiDeployment.invoke_url
}
