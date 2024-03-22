#Network Security Group
resource "azurerm_network_security_group" "nsg" {
  for_each = var.nsg_deploy ? toset(["nsg"]) : toset([])

  lifecycle {
    ignore_changes = [security_rule]
  }

  #Timeouts
  timeouts {
    create = var.nsg_timeout_create
    update = var.nsg_timeout_update
    read   = var.nsg_timeout_read
    delete = var.nsg_timeout_delete
  }

  #General
  name                = var.nsg_name
  resource_group_name = var.resource_group_object.name
  location            = coalesce(var.location, var.resource_group_object.location)
  tags                = local.tags
}