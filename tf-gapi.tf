module "manifests" {
  source = "./manifests/"
  config = var.config
}

module "tf_gapi" {
  source = "github.com/lukerops/tf-gapi.git?ref=v0.1.0"
  yamls  = concat(var.yamls, module.manifests.manifests)
}
