locals {
  kinds = try(var.resources["gcp.token-router.lukerops.com"], {})
}
