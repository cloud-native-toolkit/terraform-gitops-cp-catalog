module "gitops_cp_catalogs" {
  source = "./module"

  gitops_config = module.gitops.gitops_config
  git_credentials = module.gitops.git_credentials
  server_name = module.gitops.server_name
  kubeseal_cert = module.argocd-bootstrap.sealed_secrets_cert
  entitlement_key = "test"
}
