locals {
  core_manifests   = fileset(path.module, "./customResourceDefinition/*.{yml,yaml}")
  gcp_manifests    = var.config.gcp ? fileset(path.module, "./customResourceDefinition/gcp/*.{yml,yaml}") : []
  github_manifests = var.config.github ? fileset(path.module, "./customResourceDefinition/github/*.{yml,yaml}") : []

  manifests = flatten([local.core_manifests, local.gcp_manifests, local.github_manifests])
}

output "manifests" {
  value = [
    for manifest in local.manifests : abspath(manifest)
  ]
}
