variable "bucket_name" {
  type        = string
  description = "Type bucket name where CSV files will stored"
}
variable "s3_reader_lambda" {
  type = object({
    arn  = string
    name = string
  })
  description = "ARN and name of processing csv lambda "
}

