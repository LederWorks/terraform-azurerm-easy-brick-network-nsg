#Client Config
output "tenant_id" {
  value = module.new_nsg.tenant_id
}

output "subscription_id" {
  value = module.new_nsg.subscription_id
}

output "client_id" {
  value = module.new_nsg.client_id
}

#Resource Group
output "resource_group_name" {
  value = azurerm_resource_group.rgrp.name
}

#NSG
output "nsg" {
  value = module.new_nsg.nsg
}

output "nsg_rules" {
  value = module.new_nsg.nsg_rules
}

output "sorted_default_inbound_rules" {
  value = module.new_nsg.sorted_default_inbound_rules
}

output "sorted_default_outbound_rules" {
  value = module.new_nsg.sorted_default_outbound_rules
}