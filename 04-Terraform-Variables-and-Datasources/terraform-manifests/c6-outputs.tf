# Terraform Output Values

# EC2 Instance Public IP
output "instance_publicip" {
  description = "EC2 Instance Public IP"
  value = aws_instance.myec2vm.public_ip
}

# EC2 Instance Public DNS
output "instance_publicdns" {
  description = "EC2 Instance Public DNS"
  value = aws_instance.myec2vm.public_dns
}
# inside resource filed arguments like ami,instance type is called resource arguments
# you can declare publicip,public dns these kind of attributes from attribute section of the terraform doc in output section.