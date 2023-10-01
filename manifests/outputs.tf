locals {
  manifests        = fileset(path.module, "./customResourceDefinition/*.{yml,yaml}")
  gcp_manifests    = var.config.gcp ? fileset(path.module, "./customResourceDefinition/gcp/*.{yml,yaml}") : []
  github_manifests = var.config.github ? fileset(path.module, "./customResourceDefinition/github/*.{yml,yaml}") : []
}

output "manifests" {
  value = concat(local.manifests, local.gcp_manifests, local.github_manifests)
}
