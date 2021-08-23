output "catalog_ibmoperators" {
  description = "IBM Operator Catalog name"
  value       = "ibm-operator-catalog"
  depends_on = [null_resource.setup_gitops]
}

output "catalog_commonservices" {
  description = "IBMCS Operators catalog name"
  value       = "opencloud-operators"
  depends_on = [null_resource.setup_gitops]
}

output "catalog_automationfoundation" {
  description = "IAF Core Operators catalog name"
  value       = "iaf-core-operators"
  depends_on = [null_resource.setup_gitops]
}

output "catalog_processmining" {
  description = "IBM ProcessMining Operators catalog name"
  value       = "ibm-automation-processminings"
  depends_on = [null_resource.setup_gitops]
}
