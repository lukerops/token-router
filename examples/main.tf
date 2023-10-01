locals {
  yamls = fileset(path.module, "./manifests/*.{yml,yaml}")

  sources_data = merge(
    module.token_rute_gcp_source.data
  )
}

module "token_router" {
  source = "github.com/lukerops/token-router.git"
  yamls  = local.yamls
  config = {
    gcp    = true
    github = true
  }
}

module "token_router_gcp_sources" {
  source     = "github.com/lukerops/token-router.git//gcp/sources/"
  resources  = module.token_router.resources
  project_id = "your-project-id"
}

module "token_router_github_destinations" {
  source = "github.com/lukerops/token-router.git//github/destinations/"

  resources    = module.token_router.resources
  sources_data = local.sources_data
  organization = your-github-org
}
