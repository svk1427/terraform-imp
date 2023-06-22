# Terraform AWS Network Load Balancer (NLB)
module "nlb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "6.0.0"
  name_prefix = "mynlb-"
  #name = "complete-nlb-${random_pet.this.id}"
  load_balancer_type = "network"
  vpc_id = module.vpc.vpc_id
  subnets = module.vpc.public_subnets
  # nlb ki sg avasaram ledhu
  #  TCP Listener 
  http_tcp_listeners = [ #tcp listener antey http traffic user nundi NLB ki vasthundi
    {
      port               = 80
      protocol           = "TCP"
      target_group_index = 0
    }
  ]

  #  TLS Listener
  https_listeners = [ #tls listener antey https traffic user nundi NLB ki vasthundi
    {
      port               = 443
      protocol           = "TLS"
      certificate_arn    = module.acm.acm_certificate_arn
      target_group_index = 0 # single app, single nlg, single ASGG kabatti e value 0 vuntundi renditiki
    },
  ]

  # Target Groups 
  target_groups = [
    {
      name_prefix          = "app1-"
      backend_protocol     = "TCP"
      backend_port         = 80
      target_type          = "instance"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/app1/index.html"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
      }
    },
  ]
  tags = local.common_tags
}
