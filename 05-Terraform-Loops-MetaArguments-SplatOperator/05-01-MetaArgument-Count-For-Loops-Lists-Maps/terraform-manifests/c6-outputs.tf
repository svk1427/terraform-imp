# Terraform Output Values
/* Concepts Covered
1. For Loop with List
2. For Loop with Map
3. For Loop with Map Advanced
4. Legacy Splat Operator (latest) - Returns List
5. Latest Generalized Splat Operator - Returns the List
*/

# Output - For Loop with List
# list appudu kuda open brackets lone vundali
# instance place lo eadain evvochu and resourcename.logicalname: instance.what_output_you_want

# output "for_output_list" {
#   description = "for loop with list"
#   value = [for instance in aws_instance.myec2vm: instance.public_ip]
# }

# Output - For Loop with Map
# output "for_output_map1" {
#   description = "For Loop with Map"
#   value = {for instance in aws_instance.myec2vm: instance.id => instance.id}
# }
# #instance place lo eadain evvochu and varname.logicalname: key value pair method lo output generate chestadi
# #ekkada instance.id is key instance.publicdns is value

# Output - For Loop with Map Advanced

# output "for_output_map2" {
#   description = "For Loop with Map - Advanced"
#   value = {for c, instance in aws_instance.myec2vm: c => instance.id}
# }



# IMP: value attribute lo ela direct ga echam endukantey manam ekkada aws_instance ane oka resource use chesthunnam kabatti ela direct ga echeyochu
# ekkada manam count use cheydam valla because of that count argument ela echina thisekluntadi kani somecases lo
# manam count evvam kani list items kavali alatappudu edhi use avvadhu foreach use cheyyali
# here c maens count , how much number u given in count section it takes as a key and give value of public_dns


# Output Legacy Splat Operator (Legacy) - Returns the List

output "legacy_splat_instance_publicdns" {
  description = "Legacy Splat Operator"
  #value = aws_instance.myec2vm.public_dns //this is for get the single instance output 
  value = aws_instance.myec2vm.*.public_dns //this is for multiple instance otputs
}


# Output Latest Generalized Splat Operator - Returns the List
output "latest_splat_instance_publicdns" {
  description = "Generalized latest Splat Operator"
  value = aws_instance.myec2vm[*].public_dns
}