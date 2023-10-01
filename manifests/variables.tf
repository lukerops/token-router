variable "config" {
  type = object({
    gcp    = optional(bool, false)
    github = optional(bool, false)
  })
}
