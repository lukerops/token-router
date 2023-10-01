locals {
  kinds = try(var.resources["github.token-router.lukerops.com"], {})

  actionsSecret = try({
    for name, resource in local.kinds["ActionsSecret"] : name => resource
    if resource.spec.organization == var.organization
  }, {})
  actionsSecret_sources = try({
    for resource in values(local.actionsSecret) : resource.metadata.name => [
      for route in values(var.resources["token-router.lukerops.com"]["Route"]) : route.spec.sourceRef
      if contains(route.spec.destinations, {
        apiGroup = resource.apiGroup
        kind     = resource.kind
        name     = resource.metadata.name
      })
    ]
  }, {})

  actionsSecret_v1alpha1 = {
    for name, resource in local.actionsSecret : name => resource
    if resource.apiVersionName == "v1alpha1"
  }
}

data "github_repository" "v1alpha1" {
  for_each = local.actionsSecret_v1alpha1
  name     = each.value.spec.repository
}

resource "github_actions_secret" "v1alpha1" {
  for_each = local.actionsSecret_v1alpha1

  repository  = data.github_resitory.v1alpha1[each.key].name
  secret_name = each.value.spec.secretName
  plaintext_value = coalesce([
    for sourceRef in local.actionsSecret_sources[each.key] :
    var.resources[sourceRef.apiGroup][sourceRef.kind][sourceRef.name].data
  ])
}
