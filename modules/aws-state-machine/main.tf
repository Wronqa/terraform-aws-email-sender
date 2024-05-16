locals {
  state_machine_role   = file("${path.module}/policies/state-machine-role.json")
  invoke_lambda_policy = file("${path.module}/policies/invoke-lambda-policy.json")

}
resource "aws_iam_role" "state_machine_role" {
  name               = "emails_state_machine_role"
  assume_role_policy = local.state_machine_role
}
resource "aws_iam_policy" "invoke_lambda_policy" {
  name   = "invoke_lambda_policy"
  policy = local.invoke_lambda_policy
}
resource "aws_iam_role_policy_attachment" "invoke_lambda_policy_attachment" {
  role       = aws_iam_role.state_machine_role.name
  policy_arn = aws_iam_policy.invoke_lambda_policy.arn
}
resource "aws_sfn_state_machine" "email_send_state_machine" {
  name     = "email_send_state_machine"
  role_arn = aws_iam_role.state_machine_role.arn
  definition = templatefile("${path.module}/state-machine-template.json",
    { email_verification_arn = var.email_verification_lambda_arn,
  email_send_arn = var.email_send_lambda_arn })
}
