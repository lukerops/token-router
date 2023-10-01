variable "resources" {
  type = any
}

variable "sources_data" {
  type = map(map(map(
    object({
      apiGroup = string
      kind     = string
      name     = string
      data     = string
    })
  )))
}
