locals {
  gcp_manifests = var.config.gcp ? fileset(path.module, "./customResourceDefinition/gcp/*.{yml,yaml}") : []
}

output "manifests" {
  value = concat(local.gcp_manifests)
}
