// outputs.tf
// Key outputs to quickly find and use deployed resources.

output "resource_group_name" {
  description = "Name of the resource group for the incident lab."
  value       = module.resource_group.name
}

output "app_service_url" {
  description = "Default hostname of the App Service."
  value       = module.app_service.default_hostname
}

output "log_analytics_workspace_id" {
  description = "Log Analytics workspace ID."
  value       = module.log_analytics.workspace_id
}