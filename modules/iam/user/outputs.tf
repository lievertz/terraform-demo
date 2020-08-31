output "user_arn" {
  value       = aws_iam_user.user.arn
  description = "The ARN of the user."
}

output "user_name" {
  value       = aws_iam_user.user.name
  description = "The name of the user."
}

output "user_unique_id" {
  value       = aws_iam_user.user.unique_id
  description = "The unique id of the user."
}
