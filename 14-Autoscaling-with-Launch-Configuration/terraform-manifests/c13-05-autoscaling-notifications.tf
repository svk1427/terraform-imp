# Autoscaling Notifications
## AWS Bug for SNS Topic: https://stackoverflow.com/questions/62694223/cloudwatch-alarm-pending-confirmation
## Due to that create SNS Topic with unique name 
#sns topic same name tho create cestey we facing some issues like always iits staying in pending status

## SNS - Topic
resource "aws_sns_topic" "myasg_sns_topic" {
  name = "myasg-sns-topic-${random_pet.this.id}" #sns topic name unique ga vundadaniki e random pet anedi use cestunnam
}

## SNS - Subscription
resource "aws_sns_topic_subscription" "myasg_sns_topic_subscription" {
  topic_arn = aws_sns_topic.myasg_sns_topic.arn
  protocol  = "email" #ekkada manam mail,num eadaina echukovachu
  endpoint  = "stacksimplify@gmail.com"
}

## Create Autoscaling Notification Resource and edhi endukantey ea action jariginappudu notification vellali ani
resource "aws_autoscaling_notification" "myasg_notifications" {
  group_names = [module.autoscaling.autoscaling_group_id] # edih mana ASG name, e ASG lo jarigina actions ki notoifi veltadi,okavela mult ASG vuntey ah list lo mul ASG evvochu
  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]
  topic_arn = aws_sns_topic.myasg_sns_topic.arn 
}
