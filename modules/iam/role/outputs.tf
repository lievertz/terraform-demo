output "role_name" {
  value       = aws_iam_role.role.name
  description = "The name of the role."
}

output "role_policy_arn" {
  value       = aws_iam_policy.role_policy.arn
  description = "The ARN of the role IAM policy."
}
