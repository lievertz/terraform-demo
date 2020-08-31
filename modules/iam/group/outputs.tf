output "group_name" {
  value       = aws_iam_group.group.name
  description = "The name of the group."
}

output "group_sts_policy_arn" {
  value       = aws_iam_policy.group_sts_policy.arn
  description = "The ARN of the group STS policy."
}
