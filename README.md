# IBM Cloud Pak Operator Catalog module

Module to populate a gitops repository with the resources needed to install the operator catalogs required to install IBM Cloud Paks. Currently, four catalogs are installed:

- IBM Common Services Operator Catalog - `opencloud-operators`
- IBM Operator Catalog - `ibm-operator-catalog`
- IBM Automation Foundation Catalog - `iaf-core-operators`
- IBM Process Mining Catalog - `ibm-automation-processminings`

## Software dependencies

The module depends on the following software components:

### Command-line tools

- terraform >= v0.15
- kubectl

### Terraform providers

None

## Module dependencies

This module makes use of the output from other modules:

- GitOps 
    - github.com/cloud-native-toolkit/terraform-tools-gitops.git
- ArgoCD Bootstrap 
    - github.com/cloud-native-toolkit/terraform-tools-argocd-bootstrap.git
    - github.com/cloud-native-toolkit/terraform-vsi-argocd-bootstrap.git

## Example usage

```hcl-terraform
module "gitops_ibm_catalogs" {
  source = "github.com/cloud-native-toolkit/terraform-gitops-cp-catalogs"

}
```

