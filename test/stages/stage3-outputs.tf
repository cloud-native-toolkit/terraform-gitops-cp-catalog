
resource local_file write_outputs {
  filename = "gitops-output.json"

  content = jsonencode({
    name        = module.gitops_cp_catalogs.name
    branch      = module.gitops_cp_catalogs.branch
    namespace   = module.gitops_cp_catalogs.namespace
    server_name = module.gitops_cp_catalogs.server_name
    layer       = module.gitops_cp_catalogs.layer
    layer_dir   = module.gitops_cp_catalogs.layer == "infrastructure" ? "1-infrastructure" : (module.gitops_cp_catalogs.layer == "services" ? "2-services" : "3-applications")
    type        = module.gitops_cp_catalogs.type
  })
}
