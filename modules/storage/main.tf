// modules/storage/main.tf
// Storage account used for diagnostics / logs (if needed).

variable "resource_group_name" {
  type        = string
  description = "Resource group name."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "project_name" {
  type        = string
  description = "Project name for naming."
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply."
}

resource "azurerm_storage_account" "this" {
  name                     = replace("${var.project_name}stg", "-", "")
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = var.tags
}

output "id" {
  description = "Storage account ID."
  value       = azurerm_storage_account.this.id
}