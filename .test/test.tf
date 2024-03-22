#AppSecGroup
resource "azurerm_application_security_group" "asgr" {
  name                = "asgr-tde3-ic-terratest001"
  location            = azurerm_resource_group.rgrp.location
  resource_group_name = azurerm_resource_group.rgrp.name
}

# Module Test
module "new_nsg" {
  source = "../"

  #Subscription
  subscription_id = data.azurerm_client_config.current.subscription_id

  #Resource Group
  resource_group_object = azurerm_resource_group.rgrp

  #Tags
  tags = local.tags

  #Variables
  nsg_deploy = true
  nsg_name = "nsgr-tde3-ic-terratest001"

  nsg_timeout_create = "45m"
  nsg_timeout_update = "45m"
  nsg_timeout_read   = "4m"
  nsg_timeout_delete = "20m"

  nsg_default_rules = [
    {
      name        = "foreach1"
      description = "Any Any"
      priority    = 1000
      direction   = "Outbound"
      # access = Deny #Default Allow
      # protocol = "Tcp"

      # source_prefix = ""
      # source_prefixes = []
      # source_asg_ids = []
      # source_port = ""
      # source_ports = []

      # destination_prefix = ""
      # destination_prefixes = []
      # destination_asg_ids = []
      # destination_port = ""
      # destination_ports = []

      timeout_create = "30m"
      timeout_update = "30m"
      timeout_read   = "10m"
      timeout_delete = "30m"
    },
    {
      name              = "foreach2"
      priority          = 1010
      direction         = "Outbound"
      protocol          = "Tcp"
      source_prefix     = "10.96.205.56/29"
      destination_ports = ["80", "443"]
    },
    {
      name                = "foreach3"
      description         = "Any Any"
      priority            = 1020
      direction           = "Outbound"
      protocol            = "Udp"
      source_prefixes     = ["10.96.205.60/32", "10.96.205.61/32"]
      source_port         = "49152 - 65535"
      destination_asg_ids = [azurerm_application_security_group.asgr.id]
      destination_ports   = ["32100 - 32200", "32300"]
    },
    {
      name      = "Deny-In"
      access    = "Deny"
      priority  = 4000
      direction = "Inbound"
    },
    {
      name      = "Deny-Out"
      access    = "Deny"
      priority  = 4000
      direction = "Outbound"
    }
  ]

  # nsg_additional_rules = [
  #   {
  #     name                = "Additional-Test"
  #     priority            = 1900
  #     direction           = "Inbound"
  #     source_prefixes     = ["10.1.0.0/16", "10.2.0.0/16"]
  #     destination_asg_ids = [azurerm_application_security_group.asgr.id]
  #   }
  # ]

  nsg_custom_rules = [
    {
      name                    = "Custom-Test"
      priority                = 3000
      direction               = "Inbound"
      source_prefixes = ["10.3.0.0/16", "10.4.0.0/16"]
      destination_port_range  = "80,443"
    }
  ]
}
