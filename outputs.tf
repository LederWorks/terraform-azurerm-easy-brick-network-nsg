#Client Config
output "tenant_id" {
  value = data.azurerm_client_config.current.tenant_id
  description = "The Tenant ID of the Azure account used to deploy the Network Security Group (NSG)."
}
output "subscription_id" {
  value = data.azurerm_client_config.current.subscription_id
  description = "The Subscription ID of the Azure account used to deploy the Network Security Group (NSG)."
}
output "client_id" {
  value = data.azurerm_client_config.current.client_id
  description = "The Client ID of the Azure account used to deploy the Network Security Group (NSG)."
}

#NSG
output "nsg" {
  value = local.nsg
  description = "The Network Security Group (NSG) created by this module."
}

output "nsg_rules" {
  value = local.nsg_rules
  description = "The Network Security Group (NSG) rules created by this module."
}

output "sorted_default_rules" {
  value = local.sorted_default_rules
  description = "The Network Security Group (NSG) default rules sorted by priority."
}
