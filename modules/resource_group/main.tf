// modules/resource_group/main.tf
// Creates a dedicated resource group for the incident lab.

variable "project_name" {
  type        = string
  description = "Project name used for the resource group."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply."
}

resource "azurerm_resource_group" "this" {
  name     = "${var.project_name}-rg"
  location = var.location
  tags     = var.tags
}

output "name" {
  description = "Resource group name."
  value       = azurerm_resource_group.this.name
}