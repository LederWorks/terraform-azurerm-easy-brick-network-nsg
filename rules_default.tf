#Default Network Security Ruleset
resource "azurerm_network_security_rule" "default_rules" {
  for_each = var.nsg_default_rules != null ? {
    for obj in var.nsg_default_rules : obj.name => obj
  } : {}

  #Timeouts
  timeouts {
    create = coalesce(each.value.timeout_create, var.nsg_timeout_create)
    update = coalesce(each.value.timeout_update, var.nsg_timeout_update)
    read   = coalesce(each.value.timeout_read, var.nsg_timeout_read)
    delete = coalesce(each.value.timeout_delete, var.nsg_timeout_delete)
  }

  #General
  resource_group_name         = var.resource_group_object.name
  network_security_group_name = coalesce(azurerm_network_security_group.nsg["nsg"].name, var.nsg_name)
  name                        = each.value.name
  description                 = coalesce(each.value.description, "Security rule for ${each.value.name}")
  priority                    = each.value.priority
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol

  #Source
  source_address_prefix                 = each.value.source_prefixes != null || each.value.source_asg_ids != null ? null : each.value.source_prefix
  source_address_prefixes               = each.value.source_prefixes == null ? null : each.value.source_prefixes
  source_application_security_group_ids = each.value.source_asg_ids == null ? null : each.value.source_asg_ids
  source_port_range                     = each.value.source_ports != null ? null : each.value.source_port
  source_port_ranges                    = each.value.source_ports == null ? null : each.value.source_ports

  #Destination
  destination_address_prefix                 = each.value.destination_prefixes != null || each.value.destination_asg_ids != null ? null : each.value.destination_prefix
  destination_address_prefixes               = each.value.destination_prefixes == null ? null : each.value.destination_prefixes
  destination_application_security_group_ids = each.value.destination_asg_ids == null ? null : each.value.destination_asg_ids
  destination_port_range                     = each.value.destination_ports != null ? null : each.value.destination_port
  destination_port_ranges                    = each.value.destination_ports == null ? null : each.value.destination_ports
}

locals {
  default_rules = {
    for obj in azurerm_network_security_rule.default_rules : obj.name => obj
  }
}