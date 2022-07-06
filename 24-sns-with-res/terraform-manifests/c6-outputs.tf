# Terraform Output Values

output "sns_topic_arn" {
  description = "ARN of SNS topic"
  value       = aws_sns_topic.demo_sns.arn
}

output "sns_topic_id" {
  description = "ID of SNS topic"
  value       = aws_sns_topic.demo_sns.id
}

output "sns_topic_name" {
  description = "NAME of SNS topic"
  value       = aws_sns_topic.demo_sns.name
}

output "sns_topic_owner" {
  description = "OWNER of SNS topic"
  value       = aws_sns_topic.demo_sns.owner
}