# provider
variable "aws_region" {
  type        = string
  description = "AWS Region"
  default     = "us-west-1"
}

variable "profile" {
  type        = string
  description = "profile"
}

# vpc
variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR value"
}

variable "vpc_tag_name" {
  type        = string
  description = "VPC tag name"
}

# subnets
# variable "availability_zones" {
#   description = "A comma-delimited list of availability zones for the VPC."
# }

variable "pub_sub1_cidr" {
  type        = string
  description = "Public-Subnet1 CIDR value"
}

variable "pub_sub2_cidr" {
  type        = string
  description = "Public-Subnet2 CIDR value"
}

variable "pub_sub3_cidr" {
  type        = string
  description = "Public-Subnet3 CIDR value"
}

variable "pri_sub1_cidr" {
  type        = string
  description = "Private-Subnet1 CIDR value"
}

variable "pri_sub2_cidr" {
  type        = string
  description = "Private-Subnet2 CIDR value"
}

variable "pri_sub3_cidr" {
  type        = string
  description = "Private-Subnet3 CIDR value"
}