output "state_machine_arn" {
  value       = aws_sfn_state_machine.email_send_state_machine.arn
  description = "ARN of state machine"
}
