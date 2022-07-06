# Input Variables
# SNS topic name

variable "aws_region" {
  description = "Region in which AWS Resources to be created"
  type = string
  default = "us-east-1"
}

variable "topic_name" {
  description = "Name of the topic"
  type        = string
  default     = "sns_topic_demo"
}

# SNS display name
variable "display_name" {
  description = "Display name of the topic"
  type        = string
  default     = "sns_topic_demo"
}

variable "protocol" {
  description = "Display name of the topic"
  type        = list(string)
  default     = ["sqs", "email", "sms"]
}

variable "end_point" {
  description = "Display name of the topic"
  type        = list(string)
  default     = ["7075605001", "vamsikrishna1419@gmail.com", "vamsiintegrity@gmail.com"]
}