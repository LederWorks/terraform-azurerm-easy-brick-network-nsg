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

output "nsg_inbound_rules" {
  value = local.nsg_inbound_rules
  description = "The Inbound Network Security Group (NSG) default rules sorted by priority."
}

output "nsg_outbound_rules" {
  value = local.nsg_outbound_rules
  description = "The Outbound Network Security Group (NSG) default rules sorted by priority."
}
