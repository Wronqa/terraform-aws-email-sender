output "s3_module_output" {
  value = module.aws_s3_bucket
}
output "api_gateway" {
  value = module.aws_api_gateway
}
output "lambda" {
  value = module.aws_lambda
}
output "state_machine" {
  value = module.aws_state_machine
}
