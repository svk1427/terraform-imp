# DNS Registration 
resource "aws_route53_record" "apps_dns" {
  zone_id = data.aws_route53_zone.mydomain.zone_id 
  name    = "apps.devopsincloud.com"    #dns name ga edhi google lo hit chesinappudu req alias dwara alb dns name ki velthundi
  type    = "A"
  alias {
    name                   = module.alb.this_lb_dns_name
    zone_id                = module.alb.this_lb_zone_id
    evaluate_target_health = true
  }  
}

#3 ekkada alias antey edih internal ga alb dns name ki redirect avutundi