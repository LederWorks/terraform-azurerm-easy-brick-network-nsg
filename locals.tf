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
      name = azurerm_network_security_group.nsg["nsg"].name
      id = azurerm_network_security_group.nsg["nsg"].id
      resource_group_name = azurerm_network_security_group.nsg["nsg"].resource_group_name
      location = azurerm_network_security_group.nsg["nsg"].location
    }
  } : {}

  nsg_rules = merge(
    local.default_rules,
    local.custom_rules,
    local.additional_rules
  )
}
