provider "aws" {
  region = "us-east-1"
}

resource "aws_cloudwatch_metric_alarm" "temp" {
  
}

/* Create my terraform import command
terraform import aws_cloudwatch_metric_alarm.temp temp-alarm
terraform import aws_cloudwatch_metric_alarm.temp Synthetics-Alarm-my-manual-canary2-1
*/

#edi endukantey eadaina alaram manam tf tho create cheylenappudu manual ga 
#create chesi, ah tf cmnd ni estey a alarm ni mana infra loki state file dwara import avutadi