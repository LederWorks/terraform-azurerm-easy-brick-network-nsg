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

  # nsg_inbound_rules = [for item in local.inbound_rules : {
  #   name                 = item.name
  #   id                   = item.id
  #   access               = item.access
  #   priority             = item.priority
  #   protocol             = item.protocol
  #   source_prefix        = item.source_address_prefix
  #   source_prefixes      = item.source_address_prefixes
  #   source_asg_ids       = item.source_application_security_group_ids
  #   source_port          = item.source_port_range
  #   source_ports         = item.source_port_ranges
  #   destination_prefix   = item.destination_address_prefix
  #   destination_prefixes = item.destination_address_prefixes
  #   destination_asg_ids  = item.destination_application_security_group_ids
  #   destination_port     = item.destination_port_range
  #   destination_ports    = item.destination_port_ranges
  # }]

  #Outbound Rules
  nsg_outbound_rules = concat(
    local.sorted_default_outbound_rules,
    local.sorted_additional_outbound_rules,
    local.sorted_custom_outbound_rules
  )

  # nsg_outbound_rules = [for item in local.outbound_rules : {
  #   name                 = item.name
  #   id                   = item.id
  #   access               = item.access
  #   priority             = item.priority
  #   protocol             = item.protocol
  #   source_prefix        = item.source_address_prefix
  #   source_prefixes      = item.source_address_prefixes
  #   source_asg_ids       = item.source_application_security_group_ids
  #   source_port          = item.source_port_range
  #   source_ports         = item.source_port_ranges
  #   destination_prefix   = item.destination_address_prefix
  #   destination_prefixes = item.destination_address_prefixes
  #   destination_asg_ids  = item.destination_application_security_group_ids
  #   destination_port     = item.destination_port_range
  #   destination_ports    = item.destination_port_ranges
  # }]
}
