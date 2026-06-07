// main.tf
// High-level wiring of the incident lab environment.
// 1) Resource group
// 2) Log Analytics workspace
// 3) App Service Plan + App Service
// 4) Storage account (for logs / diagnostics)
// 5) Diagnostics + Alerts + Dashboard

module "resource_group" {
  source       = "./modules/resource_group"
  project_name = var.project_name
  location     = var.location
  tags         = var.tags
}

module "log_analytics" {
  source              = "./modules/log_analytics"
  resource_group_name = module.resource_group.name
  location            = var.location
  project_name        = var.project_name
  tags                = var.tags
}

module "app_service_plan" {
  source              = "./modules/app_service_plan"
  resource_group_name = module.resource_group.name
  location            = var.location
  project_name        = var.project_name
  tags                = var.tags
}

module "app_service" {
  source               = "./modules/app_service"
  resource_group_name  = module.resource_group.name
  location             = var.location
  project_name         = var.project_name
  app_service_plan_id  = module.app_service_plan.id
  log_analytics_id     = module.log_analytics.workspace_id
  tags                 = var.tags
}

module "storage" {
  source              = "./modules/storage"
  resource_group_name = module.resource_group.name
  location            = var.location
  project_name        = var.project_name
  tags                = var.tags
}

// Diagnostics: wire App Service + Storage into Log Analytics
module "diagnostics" {
  source = "./modules/diagnostics"

  resource_group_name = module.resource_group.name
  log_analytics_id    = module.log_analytics.workspace_id

  app_service_id      = module.app_service.id
  storage_account_id  = module.storage.id

  tags = var.tags
}

// Alerts: CPU, 5xx, availability, storage auth failures, etc.
module "alerts" {
  source = "./modules/alerts"

  resource_group_name = module.resource_group.name
  location            = var.location

  app_service_id      = module.app_service.id
  app_service_plan_id = module.app_service_plan.id
  app_service_name    = module.app_service.name
 
  log_analytics_id    = module.log_analytics.workspace_id

  tags = var.tags
}

// Dashboard: NOC-style view of app + logs + alerts
module "dashboard" {
  source = "./modules/dashboard"

  resource_group_name = module.resource_group.name
  location            = var.location
  project_name        = var.project_name

  app_service_name    = module.app_service.name
  log_analytics_id    = module.log_analytics.workspace_id

  tags = var.tags
}

#end of the file