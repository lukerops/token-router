variable "yamls" {
  type = list(string)
}

variable "config" {
  type = object({
    gcp    = optional(bool, false)
    github = optional(bool, false)
  })
}
