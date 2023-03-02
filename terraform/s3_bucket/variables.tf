variable "sse_algorithm" {
  type        = string
  description = "sse_algorithm"
  default = "AES256"
}

variable "acl" {
  type        = string
  description = "acl"
  default = "private"
}
