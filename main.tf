locals {
  name          = "ibm-catalogs"
  tmp_dir       = "${path.cwd}/.tmp/${local.name}"
  secret_dir    = "${local.tmp_dir}/secrets"
  yaml_dir      = "${path.cwd}/.tmp/${local.name}/chart/${local.name}"
  layer = "infrastructure"
  type = "base"
  secret_name  = "ibm-entitlement-key"
  catalog_name = "ibm-operator-catalog"
  application_branch = "main"
  namespace = "openshift-marketplace"
  layer_config = var.gitops_config[local.layer]
}

resource gitops_pull_secret cp_icr_io {
  name = "ibm-entitlement-key"
  namespace = local.namespace
  server_name = var.server_name
  branch = local.application_branch
  layer = local.layer
  credentials = yamlencode(var.git_credentials)
  config = yamlencode(var.gitops_config)
  kubeseal_cert = var.kubeseal_cert

  secret_name = local.secret_name
  registry_server = "cp.icr.io"
  registry_username = "cp"
  registry_password = var.entitlement_key
}

resource null_resource create_yaml {
  provisioner "local-exec" {
    command = "${path.module}/scripts/create-yaml.sh '${local.name}' '${local.yaml_dir}'"
  }
}

resource gitops_module module {
  depends_on = [null_resource.create_yaml, gitops_pull_secret.cp_icr_io]

  name = local.name
  namespace = local.namespace
  content_dir = local.yaml_dir
  server_name = var.server_name
  layer = local.layer
  type = local.type
  branch = local.application_branch
  config = yamlencode(var.gitops_config)
  credentials = yamlencode(var.git_credentials)
}
