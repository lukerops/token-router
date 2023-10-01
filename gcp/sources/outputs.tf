output "data" {
  value = {
    "gcp.token-router.lukerops.com" = {
      ServiceAccountKey = merge(
        {
          for name, source in google_service_account_key.v1alpha1 :
          name => {
            apiGroup = "gcp.token-router.lukerops.com"
            kind     = "ServiceAccountKey"
            name     = name
            data     = source.private_key
          }
        },
      )
    }
  }
}
