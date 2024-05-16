output "s3_reader_lambda" {
  value = {
    arn  = aws_lambda_function.s3_reader.arn
    name = aws_lambda_function.s3_reader.function_name
  }
  description = "ARN and name of s3 reader lambda"
}
output "email_verification_lambda_arn" {
  value       = aws_lambda_function.email_verification.arn
  description = "ARN of email verification lambda"
}

output "email_send_lambda_arn" {
  value       = aws_lambda_function.email_send.arn
  description = "ARN of email send lambda"
}
