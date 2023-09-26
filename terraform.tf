terraform {

  required_version = ">=1.3.4, < 1.6.0"

  required_providers {

      azurerm = {
        source = "hashicorp/azurerm"
        version = ">= 3.14.0, < 4.0"
      }

      azapi = {
        source = "azure/azapi"
        version = ">=0.5.0, < 1.0"
      }

      kubernetes = {
        source = "hashicorp/kubernetes"
        version = ">=2.11.0, < 3.0"
      }
  }
}
