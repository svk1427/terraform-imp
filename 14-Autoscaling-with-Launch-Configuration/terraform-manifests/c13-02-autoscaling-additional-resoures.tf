# AWS IAM Service Linked Role for Autoscaling Group
resource "aws_iam_service_linked_role" "autoscaling" {
  aws_service_name = "autoscaling.amazonaws.com"
  description      = "A service linked role for autoscaling"
  custom_suffix    = local.name

  # Sometimes good sleep is required to have some IAM resources created before they can be used
  provisioner "local-exec" {
    command = "sleep 10"
  }
}

# Output AWS IAM Service Linked Role
output "service_linked_role_arn" {
    value   = aws_iam_service_linked_role.autoscaling.arn
}

#edhoka unique IAM role edi aws services ki direct ga link avutadi config lo evvadam valla
#all permissions tho e service linked roles predefined ga vuntai, eadaina aws serv inkoka 
#servc ni mana tarupuna e role call chestadi