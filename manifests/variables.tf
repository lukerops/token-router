variable "config" {
  type = object({
    gcp = optional(bool, false)
  })
}
