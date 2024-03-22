#Network Security Group
variable "nsg_deploy" {
  description = "(Optional) Whether to deploy a Network Security Group or manage an existing one. Defaults to true."
  type        = bool
  default     = true
}

variable "nsg_name" {
  description = "(Required)The name of the Network Security Group. This is either an existing NSG, when nsg_deploy set to false or a new one to be created when set to true. Changing this forces a new resource to be created."
  type        = string
}

#Timeouts
variable "nsg_timeout_create" {
  description = "(Optional) Specify timeout for create action. Defaults to 15 minutes."
  type        = string
  default     = "15m"
}

variable "nsg_timeout_update" {
  description = "(Optional) Specify timeout for update action. Defaults to 15 minutes."
  type        = string
  default     = "15m"
}

variable "nsg_timeout_read" {
  description = "(Optional) Specify timeout for read action. Defaults to 5 minutes."
  type        = string
  default     = "5m"
}

variable "nsg_timeout_delete" {
  description = "(Optional) Specify timeout for delete action. Defaults to 15 minutes."
  type        = string
  default     = "15m"
}
