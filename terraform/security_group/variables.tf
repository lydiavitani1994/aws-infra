variable "vpc_cidr_block" {
  type        = string
  default = "0.0.0.0/0"
  description = "vpc_cidr_block"
}

variable "vpc_id" {
  type        = string
  description = "aws_vpc_id"
}

variable "description" {
  type        = string
  description = "Allow TLS inbound traffic"
  default = "value"
}

variable "tag_name" {
  type        = string
  description = "tag_name"
  default = "application"
}
