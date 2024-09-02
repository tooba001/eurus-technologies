variable "sns" {
  type = object({
    name = string
    protocol = string
    endpoint = string
  })
}

