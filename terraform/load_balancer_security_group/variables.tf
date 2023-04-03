variable "description" {
  type        = string
  description = "load balancer security group"
  default = "load balancer security group"
}

variable "tag_name" {
  type        = string
  description = "tag_name"
  default = "load_balancer"
}

variable "vpc_id" {
  type        = string
  description = "aws_vpc_id"
}

# variable "source_security_group_id" {
#   type        = string
#   description = "source_security_group_id"
# }

variable "vpc_cidr_block" {
  type        = string
  description = "vpc_cidr_block"
  default = "0.0.0.0/0"
}
