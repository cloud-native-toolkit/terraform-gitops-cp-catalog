output "name" {
  description = "The name of the module"
  value       = local.name
  depends_on  = [gitops_module.module]
}

output "branch" {
  description = "The branch where the module config has been placed"
  value       = local.application_branch
  depends_on  = [gitops_module.module]
}

output "namespace" {
  description = "The namespace where the module will be deployed"
  value       = local.namespace
  depends_on  = [gitops_module.module]
}

output "server_name" {
  description = "The server where the module will be deployed"
  value       = var.server_name
  depends_on  = [gitops_module.module]
}

output "layer" {
  description = "The layer where the module is deployed"
  value       = local.layer
  depends_on  = [gitops_module.module]
}

output "type" {
  description = "The type of module where the module is deployed"
  value       = local.type
  depends_on  = [gitops_module.module]
}

output "catalog_ibmoperators" {
  description = "IBM Operator Catalog name"
  value       = "ibm-operator-catalog"
  depends_on = [gitops_module.module]
}

output "catalog_commonservices" {
  description = "IBMCS Operators catalog name"
  value       = "opencloud-operators"
  depends_on = [gitops_module.module]
}

output "catalog_automationfoundation" {
  description = "IAF Core Operators catalog name"
  value       = "iaf-core-operators"
  depends_on = [gitops_module.module]
}

output "catalog_processmining" {
  description = "IBM ProcessMining Operators catalog name"
  value       = "ibm-automation-processminings"
  depends_on = [gitops_module.module]
}

output "entitlement_key" {
  description = "Entitlement key"
  value       = var.entitlement_key
  depends_on  = [gitops_module.module]
  sensitive   = true
}
