#Resource Group
resource "azurerm_resource_group" "RGRP" {
  name     = "RGRP"
  location = "East US 2"
  tags = local.tags
}