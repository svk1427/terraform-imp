# Autoscaling with Launch Configuration - Both created at a time
#ekkada manam ASG launch conf and ASG okesari launc chestam wit te help of module
module "autoscaling" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "4.1.0"

  # Autoscaling group
  name            = "${local.name}-myasg1"
  use_name_prefix = false
  min_size                  = 2
  max_size                  = 10
  desired_capacity          = 2
  #desired_capacity         = 3  # Changed for testing Instance Refresh as part of Step-10 
  wait_for_capacity_timeout = 0 
  health_check_type         = "EC2"
  vpc_zone_identifier       = module.vpc.private_subnets #used to were tese ASG needs to be located
  service_linked_role_arn   = aws_iam_service_linked_role.autoscaling.arn
  # Associate ALB with ASG
  target_group_arns         = module.alb.target_group_arns #this is te thing used to associate ASG with ALB

  # ASG Lifecycle Hooks
  initial_lifecycle_hooks = [ #used to how much time to wait ec2 instances launch bcz of userdata can applicale and oter res also applicable to ec2 instances thats why and after wait over wherer it need to go
    {                         # ah time ipoyaka continue avtadi as per l.no.24
      name                 = "ExampleStartupLifeCycleHook"
      default_result       = "CONTINUE"
      heartbeat_timeout    = 60
      lifecycle_transition = "autoscaling:EC2_INSTANCE_LAUNCHING"
      # This could be a rendered data resource
      notification_metadata = jsonencode({ "hello" = "world" })
    },
    {
      name                 = "ExampleTerminationLifeCycleHook"
      default_result       = "CONTINUE"
      heartbeat_timeout    = 180
      lifecycle_transition = "autoscaling:EC2_INSTANCE_TERMINATING"
      # This could be a rendered data resource
      notification_metadata = jsonencode({ "goodbye" = "world" })
    }
  ]

  # ASG Instance Referesh
  #edhi endukantey e ASG attr lo esdaina change chestey ventaney e ASG servers anevi refresh avuthai, ea changes anedhi L.no.46 lo mention chesinattu enni aiena mention cheskovachu
  # eadaina cange chesinappudu servers terminate aie kothha servers add avuthai ionstance refresh valla
  # manam general ga DC ni 3 ki set chesinappudu 3rd server launch avutadi, alunch aiena matrana
  #adhi 3rd server ga act avvadhu..e 3rd server ki L.49 lo ceppinattu 50% traffic forward avutadi
  #forward ayyaka mundu vunna 2 servers terminate ipoie 4th server ni launch chestadi
  # eppudu 3,4 servers ki traffic forward aie..1,2 servers terminate ipothai..e process antha
  #ASG lo oka part antey, eadina change infra lo jarigitey exisiting instances terminate ipoie 
  #new servers launch avuthai ah time lo downtime lekunda oka server ni launch chesi 50%
  #traffic ni forward chesi, ah exusiting servers terminate ipoyaka new infra changes tho e
  # 4th server kuda launch ipoddi so mana infra same ga work avuthundi like before

  #edantha ASG lo cange chestey ela jarugutadi and LC lo changes chestey ela vuntado kinda vundi
  instance_refresh = {  
    strategy = "Rolling"
    preferences = {
      min_healthy_percentage = 50
    }
    triggers = ["tag", "desired_capacity"] # Desired Capacity here added for demostrating the Instance Refresh scenario
  }

  # ASG Launch configuration
  lc_name   = "${local.name}-mylc1" 
  use_lc    = true
  create_lc = true

  image_id          = data.aws_ami.amzlinux2.id
  instance_type     = var.instance_type
  key_name          = var.instance_keypair
  user_data         = file("${path.module}/app1-install.sh")
  ebs_optimized     = true
  enable_monitoring = true
  
  security_groups             = [module.private_sg.security_group_id]
  associate_public_ip_address = false  # priv.sub lo instances ni associate cestam kaatti pu.ip avasaram ledhu

  # Add Spot Instances, which creates Spot Requests to get instances at the price listed (Optional argument)
  spot_price        = "0.014"
  #spot_price        = "0.016" # Change for Instance Refresh test
  #ekkada eadaina arg canges chestey entire LC delete ipoie neew LC create avuthundi
  ebs_block_device = [ # additional ga manaki vol kavakantey edih use avthundi
    {
      device_name           = "/dev/xvdz"
      delete_on_termination = true
      encrypted             = true
      volume_type           = "gp2"
      volume_size           = "20"
    },
  ]

  root_block_device = [ # default ga root volue 15 gb
    {
      delete_on_termination = true
      encrypted             = true
      volume_size           = "15"
      volume_type           = "gp2"
    },
  ]

  metadata_options = {
    http_endpoint               = "enabled"
    http_tokens                 = "optional" # At production grade you can change to "required", for our example if is optional we can get the content in metadata.html
    http_put_response_hop_limit = 32
  }

  tags        = local.asg_tags 
}
