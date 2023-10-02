locals {
  resources = module.tf_gapi.resources
  routes    = try(values(local.resources["token-router.lukerops.com"]["Route"]), [])

  source_verification = [
    for route in local.routes :
    can(local.resources[route.spec.sourceRef.apiGroup][route.spec.sourceRef.kind][route.spec.sourceRef.name])
  ]
  destination_verification = flatten([
    for route in local.routes : [
      for destination in route.spec.destinations :
      can(local.resources[destination.apiGroup][destination.kind][destination.name])
    ]
  ])
}

output "resources" {
  value = module.tf_gapi.resources

  precondition {
    condition     = alltrue(local.source_verification)
    error_message = "Source not defined."
  }

  precondition {
    condition     = alltrue(local.destination_verification)
    error_message = "Destination not defined."
  }
}
