locals {
  name          = "ibm-catalogs"
  bin_dir       = module.setup_clis.bin_dir
  tmp_dir       = "${path.cwd}/.tmp/${local.name}"
  secret_dir    = "${local.tmp_dir}/secrets"
  yaml_dir      = "${path.cwd}/.tmp/${local.name}/chart/${local.name}"
  layer = "infrastructure"
  secret_name  = "ibm-entitlement-key"
  catalog_name = "ibm-operator-catalog"
  application_branch = "main"
  layer_config = var.gitops_config[local.layer]
}

module setup_clis {
  source = "github.com/cloud-native-toolkit/terraform-util-clis.git"
}

module pull_secret {
  source = "github.com/cloud-native-toolkit/terraform-gitops-pull-secret"

  gitops_config = var.gitops_config
  git_credentials = var.git_credentials
  server_name = var.server_name
  kubeseal_cert = var.kubeseal_cert
  namespace = var.namespace
  docker_username = "cp"
  docker_password = var.entitlement_key
  docker_server   = "cp.icr.io"
  secret_name     = "ibm-entitlement-key"
}

resource null_resource create_yaml {
  provisioner "local-exec" {
    command = "${path.module}/scripts/create-yaml.sh '${local.name}' '${local.yaml_dir}'"
  }
}

module seal_secrets {
  depends_on = [null_resource.create_yaml]

  source = "github.com/cloud-native-toolkit/terraform-util-seal-secrets.git"

  source_dir    = local.secret_dir
  dest_dir      = "${local.yaml_dir}/templates"
  kubeseal_cert = var.kubeseal_cert
  label         = local.name
}

resource null_resource setup_gitops {
  depends_on = [null_resource.create_yaml]

  provisioner "local-exec" {
    command = "${local.bin_dir}/igc gitops-module '${local.name}' -n '${var.namespace}' --contentDir '${local.yaml_dir}' --serverName '${var.server_name}' -l '${local.layer}'"

    environment = {
      SECRET_DIR      = module.seal_secrets.dest_dir
      GIT_CREDENTIALS = nonsensitive(yamlencode(var.git_credentials))
      GITOPS_CONFIG   = yamlencode(var.gitops_config)
    }
  }
}
