locals {
  serviceAccountKey = try({
    for name, resource in local.kinds["ServiceAccountKey"] : name => resource
    if resource.spec.projectId == var.project_id
  }, {})
  serviceAccountKey_v1alpha1 = {
    for name, resource in local.serviceAccountKey : name => resource
    if resource.apiVersionName == "v1alpha1"
  }
}

resource "time_rotating" "serviceAccountKey_v1alpha1" {
  for_each = {
    for name, resource in local.serviceAccountKey_v1alpha1 : name => resource
    if resource.spec.rotationDays > 0
  }

  rotation_days = each.value.spec.rotationDays
}

data "google_service_account" "serviceAccountKey_v1alpha1" {
  for_each = local.serviceAccountKey_v1alpha1

  project    = each.value.spec.projectId
  account_id = each.value.spec.accountId
}

resource "google_service_account_key" "v1alpha1" {
  for_each = local.serviceAccountKey_v1alpha1

  service_account_id = data.google_service_account.serviceAccountKey_v1alpha1[each.key].name
  keepers = {
    rotation_time = try(time_rotating.serviceAccountKey_v1alpha1[each.key].rotation_rfc3339, 0)
  }
}
