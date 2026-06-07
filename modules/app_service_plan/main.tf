// modules/app_service_plan/main.tf
// App Service Plan hosting the web app.

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

resource "azurerm_service_plan" "this" {
  name                = "${var.project_name}-asp"
  location            = var.location
  resource_group_name = var.resource_group_name

  os_type  = "Linux"
  sku_name = "B1" // cheap for labs
 

  tags = var.tags
}

output "id" {
  description = "App Service Plan ID."
  value       = azurerm_service_plan.this.id
}