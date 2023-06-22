# Terraform Output Values


# EC2 Instance Public IP with TOSET
output "instance_publicip" {
  description = "EC2 Instance Public IP"
  #value = aws_instance.myec2vm.*.public_ip   # Legacy Splat
  #value = aws_instance.myec2vm[*].public_ip  # Latest Splat
  value = toset([for instance in aws_instance.myec2vm: instance.id])
}

# EC2 Instance Public DNS with TOSET
output "instance_publicdns" {
  description = "EC2 Instance Public DNS"
  #value = aws_instance.myec2vm[*].public_dns  # Legacy Splat
  #value = aws_instance.myec2vm[*].public_dns  # Latest Splat
  value = toset([for instance in aws_instance.myec2vm: instance.public_dns])
}

# EC2 Instance Public DNS with TOMAP
output "instance_publicdns2" {
  value = tomap({for az, instance in aws_instance.myec2vm: az => instance.public_dns})
}

/*
IMP: splat attribute value attribute lo ela(aws_instance.myec2vm[*].public_dns) direct ga echam undu example lo endukantey manam akkada  
aws_instance ane oka resource use chesthunnam kabatti ela direct ga echeyochu
akkada manam count use cheydam valla because of that count argument ela echina thiseskuntadi kani ekkada
manam list lo items kavali alatappudu edhi use avvadhu forloop use cheyyali

output value lo tomap,toset endukku estahm antey anni values same type loki convert avvalantey evi use cheyyali
evi enduku antey values lo ea variable values vunna convert chessestadi

# #here c maens count , how much number u given in count section it takes as a key and give value of public_dns
# # Output Legacy Splat Operator (Legacy) - Returns the List
# /*

/*
# Additional Important Note about OUTPUTS when for_each used
1. The [*] and .* operators are intended for use with lists only. 
2. Because this resource uses for_each rather than count, 
its value in other expressions is a toset or a map, not a list.
3. With that said, we can use Function "toset" and loop with "for" 
to get the output for a list
4. For maps, we can directly use for loop to get the output and if we 
want to handle type conversion we can use "tomap" function too 
*/

