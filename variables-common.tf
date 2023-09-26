# Common Variables
variable "subscription_id" {
  description = "(Required) ID of the Subscription"
  type = any
  validation {
    condition = can(regex("\\b[0-9a-f]{8}\\b-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-\\b[0-9a-f]{12}\\b", var.subscription_id))
    error_message = "Must be a valid subscription id. Ex: 9e4e50cf-5a4a-4deb-a466-9086cd9e365b."
  }
}

variable "resource_group_object" {
  description = "(Required) Resource Group Object"
  type = any
}

variable "tags" {
  description = "(Optional) Your Azure tags, as a map(string)"
  type = map(string)
  default = null
}