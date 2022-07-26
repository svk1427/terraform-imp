# Availability Zones Datasource
data "aws_availability_zones" "my_azones" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}
# EC2 Instance
resource "aws_instance" "myec2vm" {
  ami = data.aws_ami.amzlinux2.id
  instance_type = var.instance_type
  user_data = file("${path.module}/app1-install.sh")
  key_name = var.instance_keypair
  vpc_security_group_ids = [ aws_security_group.vpc-ssh.id, aws_security_group.vpc-web.id ]
  # Create EC2 Instance in all Availabilty Zones of a VPC  
  for_each = toset(data.aws_availability_zones.my_azones.names) #foreach accepts only map or setofstrings, not strings or lists
  #ekkada az anni list lo vuntai, so ah list ni e toset fun setofstrings ki convert chestadi, concvert chesina values ni each.key
  #or each.value tho refer chesi access chestam
  availability_zone = each.key  # You can also use each.value because for list items each.key == each.value
  tags = {
    "Name" = "for_each-Demo-${each.value}"
  }
}

# for each is a equalent to count but it is advanced than count , count given only count.index but foreach given maps or setofstrings
# in foreach you have to give maps or setofstrings, there is no concept like 0,1,2 ex: multiple az,subnetids
# it not accepts list like ["1", "2", "3"] so now toset function is used to converts args into setofvalue

# Since Terraforms concept of a set requires all of the elements to be of the same type, mixed-typed elements will be converted to the most general type:

# for each can work either with list and maps also , you have to use as per your requirement

# for setofstrings each.key == each.value means when you use setofstrings you can refer value with either each.value or each.key but when you use
# map you can must and should be use each.key, in map case each.key !== each.value
