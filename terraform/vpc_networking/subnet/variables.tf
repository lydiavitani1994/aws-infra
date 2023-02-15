variable "cidr_block" {
  type        = string
  description = "cidr_block"
}

variable "vpc_id" {
  type        = string
  description = "vpc_id"
}

variable "map_public_ip_on_launch" {
  type        = bool
  description = "map_public_ip_on_launch"
}

variable "availability_zone" {
  type        = string
  description = "availability_zone"
}

variable "tag_name" {
  type        = string
  description = "tag_name"
}