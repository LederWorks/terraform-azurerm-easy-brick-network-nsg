locals {
  #Tags
  tags = merge(
    var.tags,
    {
      creation_mode  = "terraform"
      module_name    = "terraform-azurerm-easy-brick-network-nsg"
      module_version = "v0.2.0"
    }
  )

  #NSG
  nsg = var.nsg_deploy ? {
    "${azurerm_network_security_group.nsg["nsg"].name}" = {
      name                = azurerm_network_security_group.nsg["nsg"].name
      id                  = azurerm_network_security_group.nsg["nsg"].id
      resource_group_name = azurerm_network_security_group.nsg["nsg"].resource_group_name
      location            = azurerm_network_security_group.nsg["nsg"].location
    }
  } : {}

  nsg_inbound_rules = concat(
    local.sorted_default_inbound_rules,
    local.sorted_additional_inbound_rules,
    local.sorted_custom_inbound_rules
  )

  nsg_outbound_rules = concat(
    local.sorted_default_outbound_rules,
    local.sorted_additional_outbound_rules,
    local.sorted_custom_outbound_rules
  )
}
