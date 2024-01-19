variable "action" {
  type    = string
  default = "deny(403)"
}

variable "preview_mode" {
  type    = string
  default = false
}

variable "owasp_rules" {
  type = map(object({
    priority   = string
    expression = string
    description = string
  }))
}
