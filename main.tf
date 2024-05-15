module "aws_s3_bucket" {
  source           = "./modules/aws-s3"
  bucket_name      = var.bucket_name
  s3_reader_lambda = module.aws_lambda.s3_reader_lambda
}
module "aws_api_gateway" {
  source = "./modules/aws-api-gateway"
  region = var.region
}
module "aws_lambda" {
  source = "./modules/aws-lambda"
}
