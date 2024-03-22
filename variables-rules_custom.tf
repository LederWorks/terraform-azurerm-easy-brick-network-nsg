#Custom Network Security Ruleset
variable "nsg_custom_rules" {
  description = <<EOT
  (Optional) List of Custom NSG Rules to be created. The nsg_custom_rules object supports the following:

  GENERAL

  • name - (Required) The name of the security rule. This needs to be unique across all Rules in the Network Security Group. Changing this forces a new resource to be created.
  • description - (Optional) A description for this rule. Restricted to 140 characters.
  • priority - (Required) Specifies the priority of the rule. The value can be between 2000 and 3999. The priority number must be unique for each rule in the collection. The lower the priority number, the higher the priority of the rule.
  • direction - (Optional) The direction specifies if rule will be evaluated on incoming or outgoing traffic. Possible values are Inbound and Outbound. Defaults to Inbound.
  • access - (Optional) Specifies whether network traffic is allowed or denied. Possible values are Allow and Deny. Defaults to Allow.
  • protocol - (Optional) Network protocol this rule applies to. Possible values include Tcp, Udp, Icmp, Esp, Ah or * (which matches all). Defaults to *.

  SOURCE

  • source_prefix - (Optional) CIDR or source IP range or * to match any IP. Tags such as VirtualNetwork, AzureLoadBalancer and Internet can also be used. This is required if source_prefixes is not specified.  Defaults to *.
  • source_prefixes - (Optional) List of source address prefixes. Tags may not be used. This is required if source_prefix is not specified.
  • source_asg_ids - (Optional) A List of source Application Security Group IDs.
  • source_port - (Optional) Source Port or Range. Integer or range between 0 and 65535 or * to match any. This is required if source_ports is not specified. Defaults to *.
  • source_ports - (Optional) List of source ports or port ranges. This is required if source_port is not specified.

  DESTINATION

  • destination_prefix - (Optional) CIDR or destination IP range or * to match any IP. Tags such as VirtualNetwork, AzureLoadBalancer and Internet can also be used, it also supports all available Service Tags like Sql.WestEurope, Storage.EastUS, etc. This is required if destination_prefixes is not specified.  Defaults to *.
  • destination_prefixes - (Optional) List of destination address prefixes. Tags may not be used. This is required if destination_prefix is not specified.
  • destination_asg_ids - (Optional) A List of destination Application Security Group IDs.
  • destination_port - (Optional) Destination Port or Range. Integer or range between 0 and 65535 or * to match any. This is required if destination_ports is not specified. Defaults to *.
  • destination_ports - (Optional) List of destination ports or port ranges. This is required if destination_port is not specified.

  TIMEOUTS

  • timeout_create - (Optional) Specify timeout for create action. Defaults to 15 minutes.
  • timeout_update - (Optional) Specify timeout for update action. Defaults to 15 minutes.
  • timeout_read - (Optional) Specify timeout for read action. Defaults to 5 minutes.
  • timeout_delete - (Optional) Specify timeout for delete action. Defaults to 15 minutes.
  EOT
  type = set(object({
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
  default = null
  validation {
    condition = var.nsg_custom_rules == null || alltrue(
      [for e in coalesce(var.nsg_custom_rules, []) : length(regexall("^[a-zA-Z][a-zA-Z0-9_.-]{0,78}[a-zA-Z0-9_]$", e.name)) > 0]
    )
    error_message = "The name can be up to 80 characters long. It must begin with a word character, and it must end with a word character or with '_'. The name may contain word characters or '.', '-', '_'."
  }
  validation {
    condition = var.nsg_custom_rules == null || alltrue(
      [for e in coalesce(var.nsg_custom_rules, []) : e.priority >= 2000 && e.priority < 4000]
    )
    error_message = "Custom Rules priority must be between 2000 and 3999."
  }
}
