output "bucket_name" {
  description = "Name of created S3 Bucker"
  value       = aws_s3_bucket.s3_bucket.bucket
}
output "bucket_arn" {
  description = "ARN of created S3 Bucker"
  value       = aws_s3_bucket.s3_bucket.arn
}
