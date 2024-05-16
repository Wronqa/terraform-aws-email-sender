module "aws_s3_bucket" {
  source           = "./modules/aws-s3"
  bucket_name      = var.bucket_name
  s3_reader_lambda = module.aws_lambda.s3_reader_lambda
}

module "aws_state_machine" {
  source                        = "./modules/aws-state-machine"
  email_send_lambda_arn         = module.aws_lambda.email_send_lambda_arn
  email_verification_lambda_arn = module.aws_lambda.email_verification_lambda_arn
}
module "aws_api_gateway" {
  source = "./modules/aws-api-gateway"
  region = var.region
}
module "aws_lambda" {
  source            = "./modules/aws-lambda"
  state_machine_arn = module.aws_state_machine.state_machine_arn
  aws_region        = var.region
  sender_email      = var.sender_email

}

