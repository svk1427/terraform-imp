# Define CloudWatch Alarms for ALB
# Alert if HTTP 4xx errors are more than threshold value
#diniki meaning eti antey eppudaitey mana app ki 400 errors ostunnayo appudeu alarm trigger avvamani
#HTTPCode_Target_4XX_Count e metric names manaki tf lo vundav kani manaki kavalantey elantivatini
#findout cheyyali AWS condole lo, ela antey go to cloudwatch->explorer->select whaterver u ewant
#here i select APPELB to get more metrics like this
#alaney metrics loki velli mana alb ki ea metrics evvocho kuda chskovacuh aws consoile lo
resource "aws_cloudwatch_metric_alarm" "alb_4xx_errors" {
  alarm_name          = "App1-ALB-HTTP-4xx-errors"
  comparison_operator = "GreaterThanThreshold"
  datapoints_to_alarm = "2" # "2"
  evaluation_periods  = "3" # "3"
  metric_name         = "HTTPCode_Target_4XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = "120"
  statistic           = "Sum"
  threshold           = "5"  # Update real-world value like 100, 200 etc
  treat_missing_data  = "missing"  
  dimensions = {
    LoadBalancer = module.alb.lb_arn_suffix
  }
  alarm_description = "This metric monitors ALB HTTP 4xx errors and if they are above 100 in specified interval, it is going to send a notification email"
  ok_actions          = [aws_sns_topic.myasg_sns_topic.arn]  
  alarm_actions     = [aws_sns_topic.myasg_sns_topic.arn]
}

# Per AppELB Metrics, evanni app alb level metrics
## - HTTPCode_ELB_5XX_Count  #500 page errors ochinappudu edhi use cheyyali like alll below
## - HTTPCode_ELB_502_Count
## - TargetResponseTime
# Per AppELB, per TG Metrics
## - UnHealthyHostCount
## - HealthyHostCount
## - HTTPCode_Target_4XX_Count
## - TargetResponseTime

