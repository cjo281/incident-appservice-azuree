// modules/log_analytics/main.tf
// Log Analytics workspace to centralize logs and metrics.

variable "resource_group_name" {
  type        = string
  description = "Resource group for the workspace."
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

resource "azurerm_log_analytics_workspace" "this" {
  name                = "${var.project_name}-law"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = var.tags
}

output "workspace_id" {
  description = "Workspace ID used by diagnostics and alerts."
  value       = azurerm_log_analytics_workspace.this.id
}