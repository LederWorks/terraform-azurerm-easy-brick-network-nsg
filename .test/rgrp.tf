#Resource Group
resource "azurerm_resource_group" "rgrp" {
  name     = "rgrp-tde3-ic-terratest-network-nsg"
  location = "germanywestcentral"
  tags = local.tags
}