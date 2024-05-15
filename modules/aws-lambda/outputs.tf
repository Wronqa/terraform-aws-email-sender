output "s3_reader_lambda" {
  value = {
    arn  = aws_lambda_function.s3_reader.arn
    name = aws_lambda_function.s3_reader.function_name
  }
  description = "ARN of s3 reader lambda"

}
