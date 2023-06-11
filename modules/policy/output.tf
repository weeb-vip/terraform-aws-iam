output "policy" {
  value = aws_iam_policy.policy
}

output "policy_arn" {
  value = aws_iam_policy.policy.arn
}
