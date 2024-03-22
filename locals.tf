locals {
  #Tags
  tags = merge(
    var.tags,
    {
      terraform-azurerm-easy-brick-network-nsg = "v0.2.0"
    }
  )

  #NSG
  nsg = var.nsg_deploy ? {
    name                = azurerm_network_security_group.nsg["nsg"].name
    id                  = azurerm_network_security_group.nsg["nsg"].id
    resource_group_name = azurerm_network_security_group.nsg["nsg"].resource_group_name
    location            = azurerm_network_security_group.nsg["nsg"].location
  } : {}

  #Inbound Rules
  nsg_inbound_rules = concat(
    local.sorted_default_inbound_rules,
    local.sorted_additional_inbound_rules,
    local.sorted_custom_inbound_rules
  )

  #Outbound Rules
  nsg_outbound_rules = concat(
    local.sorted_default_outbound_rules,
    local.sorted_additional_outbound_rules,
    local.sorted_custom_outbound_rules
  )
}
