// modules/dashboard/main.tf
// Creates an Azure Portal dashboard with tiles for App Service metrics and logs.

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

variable "app_service_name" {
  type        = string
  description = "App Service name."
}

variable "log_analytics_id" {
  type        = string
  description = "Log Analytics workspace ID."
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply (not used directly here)."
}

resource "azurerm_portal_dashboard" "this" {
  name                = "${var.project_name}-dashboard"
  resource_group_name = var.resource_group_name
  location            = var.location

  dashboard_properties = <<DASH
{
  "lenses": {
    "0": {
      "order": 0,
      "parts": {
        "0": {
          "position": {
            "x": 0,
            "y": 0,
            "rowSpan": 4,
            "colSpan": 4
          },
          "metadata": {
            "type": "Extension/HubsExtension/PartType/MarkdownPart",
            "settings": {
              "content": {
                "settings": {
                  "content": "# Incident Lab Dashboard\\nApp Service: ${var.app_service_name}"
                }
              }
            }
          }
        }
      }
    }
  },
  "metadata": {
    "model": "portal-dashboard-model"
  }
}
DASH
}