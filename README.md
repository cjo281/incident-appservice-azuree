Incident- App Service — Azure Monitor + App Service
A hands‑on lab designed to teach real monitoring skills by deploying a small environment and intentionally breaking things to observe how Azure Monitor reacts.


1. Project Overview
This lab focuses on observability, monitoring, and incident response, not on building a large infrastructure.
You deploy a minimal environment:

- App Service (Linux)

- App Service Plan

- Log Analytics Workspace

- Storage Account

- Diagnostic Settings

- Alerts (metric + log‑based)

- Azure Dashboard

Then you simulate real incidents (app crash, 5xx spike, storage auth failures, etc.) and learn:

- How Azure Monitor detects issues

- How alerts fire

- How logs flow into Log Analytics

- How to troubleshoot using KQL

- How dashboards visualize system health


2. Deployment Instructions
    1. Initialize Terraform
    
    bash

    terraform init
    
    2. Preview changes
       
    bash
   
    terraform plan
   
    3. Deploy
       
    bash
   
    terraform apply
   
    4. Outputs
       
    After deployment, Terraform prints:

    Resource group name

   App Service URL

   Log Analytics workspace ID


3. Monitoring Components
   
Log Analytics Workspace

Central location for:


  - App Service logs

  - Storage logs

  - Metrics

  - Diagnostic settings

  - Diagnostic Settings
  
Enabled for:

  - App Service

  - Storage Account

Alerts
  You get:

  - CPU > 80%

 - 5xx spike

- Storage authorization failures (403)


Dashboard

A custom Azure Portal dashboard showing:

  - App performance

  - HTTP errors

  - Storage access patterns

  - KQL tiles

  - Alert summary


4. Incident Simulation Scenarios

Scenario A — App Crash / Restart
Action: Restart the App Service or deploy a broken version.
Expected:

  - Availability drops

  - 5xx errors spike

  - Alerts fire

  - Dashboard shows red tiles

KQL to run:

kql
AppServiceHTTPLogs
| where StatusCode >= 500
| summarize count() by bin(TimeGenerated, 5m)


Scenario B — 5xx Error Storm
Action: Add a route that throws an exception.
Expected:

  - 5xx alert triggers

  - Error logs appear in Log Analytics

Scenario C — Storage Authorization Failures
Action:  
  - Try accessing the storage account with an invalid SAS token.

Expected:

  - Storage logs show 403

  - Log alert fires

KQL:

kql
StorageBlobLogs
| where StatusCode == 403

Scenario D — Logging Failure
Action:  
  - Disable diagnostic settings for App Service.

Expected:

  - Dashboard tiles show “No data”

  - Log‑based alerts stop firing

  - You learn how missing logs look in real systems



5. Repository Structure
   
incident-appsservice-azuree/

main.tf

providers.tf

variables.tf

outputs.tf

modules/

  resource_group/
  
  log_analytics/
  
  app_service_plan/
  
  app_service/
  
  storage/
  
  diagnostics/
  
  alerts/
  
  dashboard/
  
  README.md
