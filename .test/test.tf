# Module Test
module "terratest-category-purpose" {
  source = "../"

  #Subscription
  subscription_id = data.azurerm_client_config.current.subscription_id

  #Resource Group
  resource_group_object = azurerm_resource_group.RGRP

  #Tags
  tags = local.tags

  ### Global Variables ###



  ### Local Variables ###

}
