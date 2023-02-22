variable "vpc_cidr_block" {
  type        = string
  default = "10.10.0.0/16"
  description = "vpc_cidr_block"
}

variable "provider_region" {
  type        = string
  default     = "us-west-1"
  description = "provider_region"
}

variable "provider_profile" {
  type        = string
  default     = "dev"
  description = "dev/demo"
}

variable "vpc_tag_name" {
  type        = string
  default     = "dev-1"
  description = "vpc_tag_name"
}