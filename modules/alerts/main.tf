// modules/alerts/main.tf
// Creates metric and log alerts for the App Service and Storage.

variable "resource_group_name" {
  type        = string
  description = "Resource group name."
}

variable "location" {
  type        = string
  description = "Azure region."
}
variable "app_service_id" {
  type        = string
  description = "App Service resource ID."
}
variable "app_service_plan_id" {
  type        = string
  description = "App Service resource ID."
}

variable "app_service_name" {
  type        = string
  description = "App Service name (for KQL)."
}

variable "log_analytics_id" {
  type        = string
  description = "Log Analytics workspace ID."
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply (not used directly here)."
}

// Action group for notifications (email placeholder)
resource "azurerm_monitor_action_group" "email" {
  name                = "incident-lab-ag"
  resource_group_name = var.resource_group_name
  short_name          = "inc-lab"

  email_receiver {
    name          = "admin-email"
    email_address = "carl_style98@live.com" // TODO: replace with your email
  }
}

// CPU > 80% metric alert
resource "azurerm_monitor_metric_alert" "cpu_high" {
  name                = "appservice-cpu-high"
  resource_group_name = var.resource_group_name
  scopes              = [var.app_service_plan_id]
  description         = "Alert when App Service CPU exceeds 80%."
  severity            = 2
  frequency           = "PT5M"
  window_size         = "PT5M"
  auto_mitigate       = true

  criteria {
    metric_namespace = "Microsoft.Web/serverfarms"
    metric_name      = "CpuPercentage"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }

  action {
    action_group_id = azurerm_monitor_action_group.email.id
  }
}

// 5xx errors metric alert
resource "azurerm_monitor_metric_alert" "http_5xx" {
  name                = "appservice-5xx-spike"
  resource_group_name = var.resource_group_name
  scopes              = [var.app_service_id]
  description         = "Alert when 5xx errors spike."
  severity            = 2
  frequency           = "PT5M"
  window_size         = "PT5M"
  auto_mitigate       = true

  criteria {
    metric_namespace = "Microsoft.Web/sites"
    metric_name      = "Http5xx"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 10
  }

  action {
    action_group_id = azurerm_monitor_action_group.email.id
  }
}

// Log alert example: storage authorization failures (KQL)
resource "azurerm_monitor_scheduled_query_rules_alert" "storage_auth_fail" {
  name                = "storage-auth-failures"
  resource_group_name = var.resource_group_name
  location            = var.location
  description         = "Alert when storage authorization failures occur."
  severity            = 2
  enabled             = true

  data_source_id = var.log_analytics_id

  query = <<-KQL
    StorageBlobLogs
    | where StatusCode == 403
    | summarize count() by bin(TimeGenerated, 5m)
  KQL

  frequency   = 5        # minutes
  time_window = 5        # minutes

  trigger {
    operator  = "GreaterThan"
    threshold = 0
  }

  action {
    action_group = [azurerm_monitor_action_group.email.id]
  }
}