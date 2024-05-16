variable "state_machine_arn" {
  type        = string
  description = "ARN of state machine to use in python script"
}
variable "sender_email" {
  type        = string
  description = "Sender email"
}
variable "aws_region" {
  type        = string
  description = "Region of AWS Services"

}
