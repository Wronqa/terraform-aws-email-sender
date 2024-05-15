output "s3_module_output" {
  value = module.aws_s3_bucket
}
output "api_gateway" {
  value = module.aws_api_gateway
}
output "s3_reader_lambda" {
  value = module.aws_lambda.s3_reader_lambda
}
