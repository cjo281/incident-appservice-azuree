// modules/app_service/main.tf
// Simple Linux App Service with a sample container or runtime.
// Monitoring focus: availability, 5xx, performance, logs.

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

variable "app_service_plan_id" {
  type        = string
  description = "App Service Plan ID."
}

variable "log_analytics_id" {
  type        = string
  description = "Log Analytics workspace ID (for future extensions)."
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply."
}

resource "azurerm_linux_web_app" "this" {
  name                = "${var.project_name}-app"
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = var.app_service_plan_id

  https_only = true

  site_config {
    // Simple runtime; you can swap to a container image if you want.
    application_stack {
      node_version = "18-lts"
    }
  }

  tags = var.tags
}
output "id" {
  description = "App Service resource ID."
  value       = azurerm_linux_web_app.this.id
}

output "name" {
  description = "App Service name."
  value       = azurerm_linux_web_app.this.name
}

output "default_hostname" {
  description = "Default hostname to access the app."
  value       = azurerm_linux_web_app.this.default_hostname
}