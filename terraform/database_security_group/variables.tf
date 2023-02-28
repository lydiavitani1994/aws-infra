variable "description" {
  type        = string
  description = "database security group"
  default = "database security group"
}

variable "tag_name" {
  type        = string
  description = "tag_name"
  default = "database"
}

variable "vpc_id" {
  type        = string
  description = "aws_vpc_id"
}

variable "source_security_group_id" {
  type        = string
  description = "source_security_group_id"
}
