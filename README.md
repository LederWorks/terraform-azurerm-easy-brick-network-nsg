<!-- BEGIN_TF_DOCS -->
<!-- markdownlint-disable-file MD033 MD012 -->
# terraform-provider-easy-brick-network-nsg
LederWorks Easy Network Security Group brick module

This module were created by [LederWorks](https://lederworks.com) IaC enthusiasts.

## About This Module
This module implements the [SECTION](https://lederworks.com/docs/microsoft-azure/bricks/network/#section) reference Insight.

## How to Use This Modul
- Ensure Azure credentials are [in place](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs#authenticating-to-azure) (e.g. `az login` and `az account set --subscription="SUBSCRIPTION_ID"` on your workstation)
- Owner role or equivalent is required!
- Ensure pre-requisite resources are created.
- Create a Terraform configuration that pulls in this module and specifies values for the required variables.

## Requirements

The following requirements are needed by this module:

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (>= 3.64.0)

## Example

```hcl
#AppSecGroup
resource "azurerm_application_security_group" "asgr" {
  name                = "asgr-tde3-ic-terratest001"
  location            = azurerm_resource_group.rgrp.location
  resource_group_name = azurerm_resource_group.rgrp.name
}

# Test create NSG functionality
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
  nsg_name   = "nsgr-tde3-ic-terratest001"

  nsg_timeout_create = "45m"
  nsg_timeout_update = "45m"
  nsg_timeout_read   = "4m"
  nsg_timeout_delete = "20m"

  nsg_default_rules = [
    {
      name        = "New-Default01-Out"
      description = "Any Any"
      priority    = 1000
      direction   = "Outbound"
      # access = Deny #Default Allow
      # protocol = "Tcp" #Default *

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
      name              = "New-Default02-Out"
      priority          = 1010
      direction         = "Outbound"
      protocol          = "Tcp"
      source_prefix     = "10.96.205.56/29"
      destination_ports = ["80", "443"]
    },
    {
      name                = "New-Default03-Out"
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

  nsg_additional_rules = [
    {
      name                = "New-Additional01-In"
      priority            = 1900
      source_prefixes     = ["10.1.0.0/16", "10.2.0.0/16"]
      destination_asg_ids = [azurerm_application_security_group.asgr.id]
    }
  ]

  nsg_custom_rules = [
    {
      name                   = "New-Custom01-In"
      priority               = 3000
      source_prefixes        = ["10.3.0.0/16", "10.4.0.0/16"]
      destination_port_range = "80,443"
    }
  ]
}

# Test update NSG functionality
module "update_nsg" {
  source = "../"

  subscription_id       = data.azurerm_client_config.current.subscription_id
  resource_group_object = azurerm_resource_group.rgrp
  tags                  = local.tags
  nsg_deploy            = false
  nsg_name              = module.new_nsg.nsg.name

  nsg_default_rules = [
    {
      name                = "Update-Default01-In"
      priority            = 1030
      source_prefixes     = ["10.1.0.0/16", "10.2.0.0/16"]
      destination_asg_ids = [azurerm_application_security_group.asgr.id]
    }
  ]

  nsg_additional_rules = [
    {
      name                = "Update-Additional01-In"
      priority            = 1910
      source_prefixes     = ["10.1.0.0/16", "10.2.0.0/16"]
      destination_asg_ids = [azurerm_application_security_group.asgr.id]
    }
  ]

  nsg_custom_rules = [
    {
      name                   = "Update-Custom01-Out"
      priority               = 3100
      direction              = "Outbound"
      destination_port_range = "80,443"
    }
  ]
}
```

## Resources

The following resources are used by this module:

- [azurerm_network_security_group.nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) (resource)
- [azurerm_network_security_rule.additional_rules](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) (resource)
- [azurerm_network_security_rule.custom_rules](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) (resource)
- [azurerm_network_security_rule.default_rules](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_nsg_name"></a> [nsg\_name](#input\_nsg\_name)

Description: (Required)The name of the Network Security Group. This is either an existing NSG, when nsg\_deploy set to false or a new one to be created when set to true. Changing this forces a new resource to be created.

Type: `string`

### <a name="input_resource_group_object"></a> [resource\_group\_object](#input\_resource\_group\_object)

Description: (Required) Resource Group Object

Type: `any`

### <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id)

Description: (Required) ID of the Subscription

Type: `any`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_location"></a> [location](#input\_location)

Description: (Optional) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created. When not specified resource\_group\_object.location will be used.

Type: `string`

Default: `null`

### <a name="input_nsg_additional_rules"></a> [nsg\_additional\_rules](#input\_nsg\_additional\_rules)

Description:   (Optional) List of Additional NSG Rules to be created. The nsg\_additional\_rules object supports the following:

  GENERAL

  • name - (Required) The name of the security rule. This needs to be unique across all Rules in the Network Security Group. Changing this forces a new resource to be created.
  • description - (Optional) A description for this rule. Restricted to 140 characters.
  • priority - (Required) Specifies the priority of the rule. The value can be between 1800 and 1999. The priority number must be unique for each rule in the collection. The lower the priority number, the higher the priority of the rule.
  • direction - (Optional) The direction specifies if rule will be evaluated on incoming or outgoing traffic. Possible values are Inbound and Outbound. Defaults to Inbound.
  • access - (Optional) Specifies whether network traffic is allowed or denied. Possible values are Allow and Deny. Defaults to Allow.
  • protocol - (Optional) Network protocol this rule applies to. Possible values include Tcp, Udp, Icmp, Esp, Ah or * (which matches all). Defaults to *.

  SOURCE

  • source\_prefix - (Optional) CIDR or source IP range or * to match any IP. Tags such as VirtualNetwork, AzureLoadBalancer and Internet can also be used. This is required if source\_prefixes is not specified.  Defaults to *.
  • source\_prefixes - (Optional) List of source address prefixes. Tags may not be used. This is required if source\_prefix is not specified.
  • source\_asg\_ids - (Optional) A List of source Application Security Group IDs.
  • source\_port - (Optional) Source Port or Range. Integer or range between 0 and 65535 or * to match any. This is required if source\_ports is not specified. Defaults to *.
  • source\_ports - (Optional) List of source ports or port ranges. This is required if source\_port is not specified.

  DESTINATION

  • destination\_prefix - (Optional) CIDR or destination IP range or * to match any IP. Tags such as VirtualNetwork, AzureLoadBalancer and Internet can also be used, it also supports all available Service Tags like Sql.WestEurope, Storage.EastUS, etc. This is required if destination\_prefixes is not specified.  Defaults to *.
  • destination\_prefixes - (Optional) List of destination address prefixes. Tags may not be used. This is required if destination\_prefix is not specified.
  • destination\_asg\_ids - (Optional) A List of destination Application Security Group IDs.
  • destination\_port - (Optional) Destination Port or Range. Integer or range between 0 and 65535 or * to match any. This is required if destination\_ports is not specified. Defaults to *.
  • destination\_ports - (Optional) List of destination ports or port ranges. This is required if destination\_port is not specified.

  TIMEOUTS

  • timeout\_create - (Optional) Specify timeout for create action. Defaults to 15 minutes.
  • timeout\_update - (Optional) Specify timeout for update action. Defaults to 15 minutes.
  • timeout\_read - (Optional) Specify timeout for read action. Defaults to 5 minutes.
  • timeout\_delete - (Optional) Specify timeout for delete action. Defaults to 15 minutes.

Type:

```hcl
set(object({
    name        = string
    description = optional(string)
    priority    = number
    direction   = optional(string, "Inbound")
    access      = optional(string, "Allow")
    protocol    = optional(string, "*")
    #Source
    source_prefix   = optional(string, "*")
    source_prefixes = optional(list(string))
    source_asg_ids  = optional(list(string))
    source_port     = optional(string, "*")
    source_ports    = optional(list(string))
    #Destination
    destination_prefix   = optional(string, "*")
    destination_prefixes = optional(list(string))
    destination_asg_ids  = optional(list(string))
    destination_port     = optional(string, "*")
    destination_ports    = optional(list(string))
    #Timeouts
    timeout_create = optional(string)
    timeout_update = optional(string)
    timeout_read   = optional(string)
    timeout_delete = optional(string)
  }))
```

Default: `null`

### <a name="input_nsg_custom_rules"></a> [nsg\_custom\_rules](#input\_nsg\_custom\_rules)

Description:   (Optional) List of Custom NSG Rules to be created. The nsg\_custom\_rules object supports the following:

  GENERAL

  • name - (Required) The name of the security rule. This needs to be unique across all Rules in the Network Security Group. Changing this forces a new resource to be created.
  • description - (Optional) A description for this rule. Restricted to 140 characters.
  • priority - (Required) Specifies the priority of the rule. The value can be between 2000 and 3999. The priority number must be unique for each rule in the collection. The lower the priority number, the higher the priority of the rule.
  • direction - (Optional) The direction specifies if rule will be evaluated on incoming or outgoing traffic. Possible values are Inbound and Outbound. Defaults to Inbound.
  • access - (Optional) Specifies whether network traffic is allowed or denied. Possible values are Allow and Deny. Defaults to Allow.
  • protocol - (Optional) Network protocol this rule applies to. Possible values include Tcp, Udp, Icmp, Esp, Ah or * (which matches all). Defaults to *.

  SOURCE

  • source\_prefix - (Optional) CIDR or source IP range or * to match any IP. Tags such as VirtualNetwork, AzureLoadBalancer and Internet can also be used. This is required if source\_prefixes is not specified.  Defaults to *.
  • source\_prefixes - (Optional) List of source address prefixes. Tags may not be used. This is required if source\_prefix is not specified.
  • source\_asg\_ids - (Optional) A List of source Application Security Group IDs.
  • source\_port - (Optional) Source Port or Range. Integer or range between 0 and 65535 or * to match any. This is required if source\_ports is not specified. Defaults to *.
  • source\_ports - (Optional) List of source ports or port ranges. This is required if source\_port is not specified.

  DESTINATION

  • destination\_prefix - (Optional) CIDR or destination IP range or * to match any IP. Tags such as VirtualNetwork, AzureLoadBalancer and Internet can also be used, it also supports all available Service Tags like Sql.WestEurope, Storage.EastUS, etc. This is required if destination\_prefixes is not specified.  Defaults to *.
  • destination\_prefixes - (Optional) List of destination address prefixes. Tags may not be used. This is required if destination\_prefix is not specified.
  • destination\_asg\_ids - (Optional) A List of destination Application Security Group IDs.
  • destination\_port - (Optional) Destination Port or Range. Integer or range between 0 and 65535 or * to match any. This is required if destination\_ports is not specified. Defaults to *.
  • destination\_ports - (Optional) List of destination ports or port ranges. This is required if destination\_port is not specified.

  TIMEOUTS

  • timeout\_create - (Optional) Specify timeout for create action. Defaults to 15 minutes.
  • timeout\_update - (Optional) Specify timeout for update action. Defaults to 15 minutes.
  • timeout\_read - (Optional) Specify timeout for read action. Defaults to 5 minutes.
  • timeout\_delete - (Optional) Specify timeout for delete action. Defaults to 15 minutes.

Type:

```hcl
set(object({
    #General
    name        = string
    description = optional(string)
    priority    = number
    direction   = optional(string, "Inbound")
    access      = optional(string, "Allow")
    protocol    = optional(string, "*")
    #Source
    source_prefix   = optional(string, "*")
    source_prefixes = optional(list(string))
    source_asg_ids  = optional(list(string))
    source_port     = optional(string, "*")
    source_ports    = optional(list(string))
    #Destination
    destination_prefix   = optional(string, "*")
    destination_prefixes = optional(list(string))
    destination_asg_ids  = optional(list(string))
    destination_port     = optional(string, "*")
    destination_ports    = optional(list(string))
    #Timeouts
    timeout_create = optional(string)
    timeout_update = optional(string)
    timeout_read   = optional(string)
    timeout_delete = optional(string)
  }))
```

Default: `null`

### <a name="input_nsg_default_rules"></a> [nsg\_default\_rules](#input\_nsg\_default\_rules)

Description:   (Optional) List of Default NSG Rules to be created. The nsg\_default\_rules object supports the following:

  GENERAL

  • name - (Required) The name of the security rule. This needs to be unique across all Rules in the Network Security Group. Changing this forces a new resource to be created.
  • description - (Optional) A description for this rule. Restricted to 140 characters.
  • priority - (Required) Specifies the priority of the rule. The value can be between 1000 and 1799. Priority 4000 also allowed for Deny All rule. The priority number must be unique for each rule in the collection. The lower the priority number, the higher the priority of the rule.
  • direction - (Optional) The direction specifies if rule will be evaluated on incoming or outgoing traffic. Possible values are Inbound and Outbound. Defaults to Inbound.
  • access - (Optional) Specifies whether network traffic is allowed or denied. Possible values are Allow and Deny. Defaults to Allow.
  • protocol - (Optional) Network protocol this rule applies to. Possible values include Tcp, Udp, Icmp, Esp, Ah or * (which matches all). Defaults to *.

  SOURCE

  • source\_prefix - (Optional) CIDR or source IP range or * to match any IP. Tags such as VirtualNetwork, AzureLoadBalancer and Internet can also be used. This is required if source\_prefixes is not specified.  Defaults to *.
  • source\_prefixes - (Optional) List of source address prefixes. Tags may not be used. This is required if source\_prefix is not specified.
  • source\_asg\_ids - (Optional) A List of source Application Security Group IDs.
  • source\_port - (Optional) Source Port or Range. Integer or range between 0 and 65535 or * to match any. This is required if source\_ports is not specified. Defaults to *.
  • source\_ports - (Optional) List of source ports or port ranges. This is required if source\_port is not specified.

  DESTINATION

  • destination\_prefix - (Optional) CIDR or destination IP range or * to match any IP. Tags such as VirtualNetwork, AzureLoadBalancer and Internet can also be used, it also supports all available Service Tags like Sql.WestEurope, Storage.EastUS, etc. This is required if destination\_prefixes is not specified.  Defaults to *.
  • destination\_prefixes - (Optional) List of destination address prefixes. Tags may not be used. This is required if destination\_prefix is not specified.
  • destination\_asg\_ids - (Optional) A List of destination Application Security Group IDs.
  • destination\_port - (Optional) Destination Port or Range. Integer or range between 0 and 65535 or * to match any. This is required if destination\_ports is not specified. Defaults to *.
  • destination\_ports - (Optional) List of destination ports or port ranges. This is required if destination\_port is not specified.

  TIMEOUTS

  • timeout\_create - (Optional) Specify timeout for create action. Defaults to 15 minutes.
  • timeout\_update - (Optional) Specify timeout for update action. Defaults to 15 minutes.
  • timeout\_read - (Optional) Specify timeout for read action. Defaults to 5 minutes.
  • timeout\_delete - (Optional) Specify timeout for delete action. Defaults to 15 minutes.

Type:

```hcl
set(object({
    name        = string
    description = optional(string)
    priority    = number
    direction   = optional(string, "Inbound")
    access      = optional(string, "Allow")
    protocol    = optional(string, "*")
    #Source
    source_prefix   = optional(string, "*")
    source_prefixes = optional(list(string))
    source_asg_ids  = optional(list(string))
    source_port     = optional(string, "*")
    source_ports    = optional(list(string))
    #Destination
    destination_prefix   = optional(string, "*")
    destination_prefixes = optional(list(string))
    destination_asg_ids  = optional(list(string))
    destination_port     = optional(string, "*")
    destination_ports    = optional(list(string))
    #Timeouts
    timeout_create = optional(string)
    timeout_update = optional(string)
    timeout_read   = optional(string)
    timeout_delete = optional(string)
  }))
```

Default: `null`

### <a name="input_nsg_deploy"></a> [nsg\_deploy](#input\_nsg\_deploy)

Description: (Optional) Whether to deploy a Network Security Group or manage an existing one. Defaults to true.

Type: `bool`

Default: `true`

### <a name="input_nsg_timeout_create"></a> [nsg\_timeout\_create](#input\_nsg\_timeout\_create)

Description: (Optional) Specify timeout for create action. Defaults to 15 minutes.

Type: `string`

Default: `"15m"`

### <a name="input_nsg_timeout_delete"></a> [nsg\_timeout\_delete](#input\_nsg\_timeout\_delete)

Description: (Optional) Specify timeout for delete action. Defaults to 15 minutes.

Type: `string`

Default: `"15m"`

### <a name="input_nsg_timeout_read"></a> [nsg\_timeout\_read](#input\_nsg\_timeout\_read)

Description: (Optional) Specify timeout for read action. Defaults to 5 minutes.

Type: `string`

Default: `"5m"`

### <a name="input_nsg_timeout_update"></a> [nsg\_timeout\_update](#input\_nsg\_timeout\_update)

Description: (Optional) Specify timeout for update action. Defaults to 15 minutes.

Type: `string`

Default: `"15m"`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: (Optional) Your Azure tags, as a map(string)

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_client_id"></a> [client\_id](#output\_client\_id)

Description: The Client ID of the Azure account used to deploy the Network Security Group (NSG).

### <a name="output_nsg"></a> [nsg](#output\_nsg)

Description: The Network Security Group (NSG) created by this module.

### <a name="output_nsg_inbound_rules"></a> [nsg\_inbound\_rules](#output\_nsg\_inbound\_rules)

Description: The Inbound Network Security Group (NSG) default rules sorted by priority.

### <a name="output_nsg_outbound_rules"></a> [nsg\_outbound\_rules](#output\_nsg\_outbound\_rules)

Description: The Outbound Network Security Group (NSG) default rules sorted by priority.

### <a name="output_subscription_id"></a> [subscription\_id](#output\_subscription\_id)

Description: The Subscription ID of the Azure account used to deploy the Network Security Group (NSG).

### <a name="output_tenant_id"></a> [tenant\_id](#output\_tenant\_id)

Description: The Tenant ID of the Azure account used to deploy the Network Security Group (NSG).

<!-- markdownlint-disable-file MD033 MD012 -->
## Contributing

* If you think you've found a bug in the code or you have a question regarding
  the usage of this module, please reach out to us by opening an issue in
  this GitHub repository.
* Contributions to this project are welcome: if you want to add a feature or a
  fix a bug, please do so by opening a Pull Request in this GitHub repository.
  In case of feature contribution, we kindly ask you to open an issue to
  discuss it beforehand.

## License

```text
MIT License

Copyright (c) 2024 LederWorks

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
<!-- END_TF_DOCS -->