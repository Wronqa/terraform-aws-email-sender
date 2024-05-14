module "aws_s3_bucket" {
  source      = "./modules/aws-s3"
  bucket_name = var.bucket_name
}
module "aws_api_gateway" {
  source = "./modules/aws-api-gateway"
  region = var.region

}
