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
  description = "vpc_tag_name"
}