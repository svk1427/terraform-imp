# # AWS EC2 Instance Terraform Module
# # EC2 Instances that will be created in VPC Private Subnets
# module "ec2_private" {
#   depends_on = [ module.vpc ] # VERY VERY IMPORTANT else userdata webserver provisioning will fail
#   source  = "./modules/aws-ec2"
#   #version = "2.17.0"
#   # insert the 10 required variables here
#   name                   = "${var.environment}-vm"
#   ami                    = data.aws_ami.amzlinux2.id
#   instance_type          = var.instance_type
#   key_name               = var.instance_keypair
#   #monitoring             = true
#   vpc_security_group_ids = [module.private_sg.security_group_id]
#   #subnet_id              = module.vpc.public_subnets[0]  
#   subnet_ids = [ //manaki ela eadaina extra arguement add cheyyalsi ostey mundu modules var file lo e argument ni declare cheyyali otherwise errors osthai
#     module.vpc.private_subnets[0],
#     module.vpc.private_subnets[1]
#   ]  
#   instance_count         = var.private_instance_count
#   user_data = file("${path.module}/app1-install.sh")
#   tags = local.common_tags
# }

module "ec2_private" {
  depends_on = [ module.vpc ] # VERY VERY IMPORTANT else userdata webserver provisioning will fail
  source  = "./modules/aws-ec2"
  #version = "2.17.0"
  #for_each = toset([ module.vpc.private_subnets[0],module.vpc.private_subnets[1] ])
  for_each = toset(["0", "1"])
  # insert the 10 required variables here
  name                   = "${var.environment}-vm-${each.key}"
  ami                    = data.aws_ami.amzlinux2.id
  instance_type          = var.instance_type
  key_name               = var.instance_keypair
  #monitoring             = true
  vpc_security_group_ids = [module.private_sg.security_group_id]
  subnet_id =  element(module.vpc.private_subnets, tonumber(each.value)) 
  #List nundi values osthunnai kabatti ekkada each.key / each.value eadhi echina parledhu adey map nundi osthey must and should ga eack.key ea thiskovali
  instance_count         = var.private_instance_count
  user_data = file("${path.module}/app1-install.sh")
  tags = local.common_tags
}

#element retrieves te value of a single element from a list. in the above first convert list into 
#setofstring and get the value with element function.
#Element syntax - element(list, index)
#tonumber converts its argument to a number value.

#lookup retrieves the value of a single element from a map, given its key. If the given key does not exist, the given default value is returned instead.