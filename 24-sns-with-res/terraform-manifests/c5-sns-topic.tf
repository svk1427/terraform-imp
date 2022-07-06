# SNS topic
resource "aws_sns_topic" "demo_sns" {
  name            = var.topic_name
  display_name    = var.display_name
  delivery_policy = <<EOF
{
  "http": {
    "defaultHealthyRetryPolicy": {
      "minDelayTarget": 20,
      "maxDelayTarget": 20,
      "numRetries": 3,
      "numMaxDelayRetries": 0,
      "numNoDelayRetries": 0,
      "numMinDelayRetries": 0,
      "backoffFunction": "linear"
    },
    "disableSubscriptionOverrides": false,
    "defaultThrottlePolicy": {
      "maxReceivesPerSecond": 1
    }
  }
}
EOF
}

#SNS TOPIC SUBSCRIPTION

resource "aws_sns_topic_subscription" "target_sqs" {
  topic_arn = aws_sns_topic.demo_sns.arn
  protocol  = var.protocol[1]
  endpoint  = var.end_point[2]
}
