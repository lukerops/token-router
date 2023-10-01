locals {
  manifests     = fileset(path.module, "./customResourceDefinition/*.{yml,yaml}")
  gcp_manifests = var.config.gcp ? fileset(path.module, "./customResourceDefinition/gcp/*.{yml,yaml}") : []
}

output "manifests" {
  value = concat(local.manifests, local.gcp_manifests)
}
