# Terraform AWS Application Load Balancer (ALB)
module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  #version = "5.16.0"
  version = "6.0.0"

  name = "${local.name}-alb"
  load_balancer_type = "application"
  vpc_id = module.vpc.vpc_id
  subnets = [
    module.vpc.public_subnets[0],
    module.vpc.public_subnets[1]
  ]
  security_groups = [module.loadbalancer_sg.this_security_group_id]
  # Listeners
  # HTTP Listener - HTTP to HTTPS Redirect
    http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      action_type = "redirect"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
  ]  
  # Target Groups
  target_groups = [
    # App1 Target Group - TG Index = 0
    {
      name_prefix          = "app1-"
      backend_protocol     = "HTTP"
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
        protocol            = "HTTP"
        matcher             = "200-399"
      }
      protocol_version = "HTTP1"
      # App1 Target Group - Targets
      targets = {
        my_app1_vm1 = {
          target_id = module.ec2_private_app1.id[0]
          port      = 80
        },
        my_app1_vm2 = {
          target_id = module.ec2_private_app1.id[1]
          port      = 80
        }
      }
      tags =local.common_tags # Target Group Tags
    },  
    # App2 Target Group - TG Index = 1
    {
      name_prefix          = "app2-"
      backend_protocol     = "HTTP"
      backend_port         = 80
      target_type          = "instance"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/app2/index.html"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
      protocol_version = "HTTP1"
      # App2 Target Group - Targets
      targets = {
        my_app2_vm1 = {
          target_id = module.ec2_private_app2.id[0]
          port      = 80
        },
        my_app2_vm2 = {
          target_id = module.ec2_private_app2.id[1]
          port      = 80
        }
      }
      tags =local.common_tags # Target Group Tags
    }  
  ]

  # HTTPS Listener
  https_listeners = [
    # HTTPS Listener Index = 0 for HTTPS 443
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = module.acm.this_acm_certificate_arn
      action_type = "fixed-response"
      fixed_response = {
        content_type = "text/plain"
        message_body = "Fixed Static message - for Root Context"
        status_code  = "200"
      }
    }, 
  ]
 
  # HTTPS Listener Rules
  https_listener_rules = [
    # Rule-1: custom-header=my-app-1 should go to App1 EC2 Instances
    # CH antey values lo vunna eadih ch ga echina adhi ah specified tg ki redirect ki velthundi
    { 
      https_listener_index = 0
      priority = 1      
      actions = [
        {
          type               = "forward"
          target_group_index = 0
        }
      ]
      conditions = [{ 
        #path_patterns = ["/app1*"]
        #host_headers = [var.app1_dns_name]
        http_headers = [{
          http_header_name = "custom-header"
          values           = ["app-1", "app1", "my-app-1"]
        }]
      }]
    },
    # Rule-2: custom-header=my-app-2 should go to App2 EC2 Instances    
    {
      https_listener_index = 0
      priority = 2      
      actions = [
        {
          type               = "forward" #forward antey traffic ah particular path ki forward cestadi same website lo
          target_group_index = 1
        }
      ]
      conditions = [{
        #path_patterns = ["/app2*"] 
        #host_headers = [var.app2_dns_name]
        http_headers = [{
          http_header_name = "custom-header"
          values           = ["app-2", "app2", "my-app-2"] # e values list lo vunnai kabatti enni values aiena thiskuntadi
        }]        
      }]
    },    
  # Rule-3: When Query-String, website=aws-eks redirect to https://stacksimplify.com/aws-eks/
    { 
      https_listener_index = 0
      priority = 3 # e priority anedhi oka rule tarvata okati exec avvadaniki use avutadi
      actions = [{
        type        = "redirect" # redirect antey mean ea inkoka website nundi ochina req ni mana alb handle cesi ah particular host ki ah path ki redirect chestadi

        status_code = "HTTP_302" # 302 status antey inkooka website ki redirect avvaamni
        host        = "stacksimplify.com" # e website ki redirect aie
        path        = "/aws-eks/" # e path loki velli website open avutadui
        query       = ""
        protocol    = "HTTPS" # https website with SSL cert thoh open avutadi
      }]
      conditions = [{
        query_strings = [{  #query string antey oka lb nundi inkoka websiite ki redirect avuthundi
          key   = "website"
          value = "aws-eks"
          }]
      }]
    },
  # Rule-4: When Host Header = azure-aks.devopsincloud.com, redirect to https://stacksimplify.com/azure-aks/azure-kubernetes-service-introduction/
  # ekkada echina prathi domain name c12 file lo register avvali ala iteyne work avuthai
    { 
      https_listener_index = 0
      priority = 4
      actions = [{
        type        = "redirect" # redirect antey mean ea inkoka website nundi ochina req ni mana alb handle cesi ah particular host ki ah path ki redirect chestadi
        status_code = "HTTP_302"
        host        = "stacksimplify.com"
        path        = "/azure-aks/azure-kubernetes-service-introduction/"
        query       = ""
        protocol    = "HTTPS"
      }]
      conditions = [{
        host_headers = ["azure-aks101.devopsincloud.com"] #host header antey e website nundi req ragane adhi paina vunna stackimplify website ki velli ah part path website ni display chestadi
      }]
    },    
  ]
  tags = local.common_tags # ALB Tags
}
