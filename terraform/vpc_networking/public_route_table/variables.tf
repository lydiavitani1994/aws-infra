variable "cidr_block" {
  type        = string
  default = "0.0.0.0/0"
  description = "cidr_block"
}

variable "vpc_id" {
  type        = string
  description = "vpc_id"
}

variable "gateway_id" {
  type        = string
  description = "gateway_id"
}

variable "tag_name" {
  type        = string
  description = "subnet_tag_name"
}