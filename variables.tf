// variables.tf
// Global variables for the incident lab.

variable "project_name" {
  description = "Short name for this incident lab project, used for naming."
  type        = string
  default     = "incident-lab"
}

variable "location" {
  description = "Azure region for all resources."
  type        = string
  default     = "centralus"
}

variable "tags" {
  description = "Common tags applied to all resources."
  type        = map(string)
  default = {
    environment = "lab"
    owner       = "car"
    purpose     = "monitoring-incident-simulation"
  }
}