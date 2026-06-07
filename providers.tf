// providers.tf
// Configures the AzureRM provider and required features.

terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      # This allows Terraform to wipe the RG even if it's not empty
      prevent_deletion_if_contains_resources = false
    }
  }
}