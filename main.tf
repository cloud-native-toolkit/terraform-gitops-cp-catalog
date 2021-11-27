locals {
  name          = "ibm-catalogs"
  bin_dir       = module.setup_clis.bin_dir
  tmp_dir       = "${path.cwd}/.tmp/${local.name}"
  secret_dir    = "${local.tmp_dir}/secrets"
  yaml_dir      = "${path.cwd}/.tmp/${local.name}/chart/${local.name}"
  layer = "services"
  type  = "operators"
  secret_name  = "ibm-entitlement-key"
  catalog_name = "ibm-operator-catalog"
  application_branch = "main"
  layer_config = var.gitops_config[local.layer]
}

module setup_clis {
  source = "github.com/cloud-native-toolkit/terraform-util-clis.git"
}

resource "null_resource" "create_secrets" {
  count = var.entitlement_key != "" ? 1 : 0

  provisioner "local-exec" {
    command = "${path.module}/scripts/create-pull-secret.sh ${var.namespace} ${local.secret_name} ${local.secret_dir}"

    environment = {
      ENTITLEMENT_KEY = var.entitlement_key
    }
  }
}

resource null_resource create_yaml {
  provisioner "local-exec" {
    command = "${path.module}/scripts/create-yaml.sh '${local.name}' '${local.yaml_dir}'"
  }
}

module seal_secrets {
  depends_on = [null_resource.create_secrets, null_resource.create_yaml]

  source = "github.com/cloud-native-toolkit/terraform-util-seal-secrets.git?ref=v1.0.0"

  source_dir    = local.secret_dir
  dest_dir      = "${local.yaml_dir}/templates"
  kubeseal_cert = var.kubeseal_cert
  label         = local.name
}

resource null_resource setup_gitops {
  depends_on = [null_resource.create_yaml, null_resource.create_secrets]

  provisioner "local-exec" {
    command = "${local.bin_dir}/igc gitops-module '${local.name}' -n '${var.namespace}' --contentDir '${local.yaml_dir}' --serverName '${var.server_name}' -l '${local.layer}' --type ${local.type}"

    environment = {
      SECRET_DIR      = module.seal_secrets.dest_dir
      GIT_CREDENTIALS = nonsensitive(yamlencode(var.git_credentials))
      GITOPS_CONFIG   = yamlencode(var.gitops_config)
    }
  }
}
