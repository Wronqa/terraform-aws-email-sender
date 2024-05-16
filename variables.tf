variable "region" {
  type        = string
  description = "Type region name to create resources them"
}
variable "bucket_name" {
  type        = string
  description = "Type bucket name where CSV files will stored"
}
variable "sender_email" {
  type        = string
  description = "Sender email"
}

