// modules/diagnostics/main.tf
// Connects App Service and Storage to Log Analytics via diagnostic settings.

variable "resource_group_name" {
  type        = string
  description = "Resource group name."
}

variable "log_analytics_id" {
  type        = string
  description = "Log Analytics workspace ID."
}

variable "app_service_id" {
  type        = string
  description = "App Service resource ID."
}

variable "storage_account_id" {
  type        = string
  description = "Storage account resource ID."
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply (not used directly here but kept for consistency)."
}

// App Service diagnostics -> Log Analytics
resource "azurerm_monitor_diagnostic_setting" "app_service" {
  name                       = "appservice-to-law"
  target_resource_id         = var.app_service_id
  log_analytics_workspace_id = var.log_analytics_id

  enabled_log {
    category = "AppServiceHTTPLogs"
  }

  enabled_log {
    category = "AppServiceConsoleLogs"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

// Storage diagnostics -> Log Analytics
resource "azurerm_monitor_diagnostic_setting" "storage" {
  name                       = "storage-to-law"
  target_resource_id         = "${var.storage_account_id}/blobServices/default"
  log_analytics_workspace_id = var.log_analytics_id

  enabled_log {
    category = "StorageRead"
  }

  enabled_log {
    category = "StorageWrite"
  }

  enabled_log {
    category = "StorageDelete"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}