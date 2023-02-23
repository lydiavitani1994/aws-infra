# provider
# variable "provider_region" {
#   type        = string
#   default = "us-west-1"
#   description = "provider_region"
# }

# variable "provider_profile" {
#   type        = string
#   default = "dev"
#   description = "dev/demo"
# }

# vpc
variable "vpc_cidr" {
  type        = string
  default = "10.10.0.0/16"
  description = "VPC CIDR value"
}

variable "vpc_tag_name" {
  type        = string
  default = "yumeng_vpc"
  description = "VPC tag name"
}

# data
variable "data_state" {
  type        = string
  default = "available"
  description = "data state"
}

# eip
variable "aws_eip_vpc" {
  type        = bool
  default     = true
  description = "VPC"
}

variable "aws_eip_tag_name" {
  type        = string
  default     = "vpc-arun"
  description = "aws_eip tag name"
}

# Internet Gateway
variable "aws_internet_gateway_tag_name" {
  type        = string
  default     = "igw-arun"
  description = "aws_internet_gateway_tag_name"
}

# subnet
variable "pub_sub1_cidr" {
  type        = string
  default = "10.10.0.0/24"
  description = "Public-Subnet1 CIDR value"
}

variable "pub_sub2_cidr" {
  type        = string
  default = "10.10.1.0/24"
  description = "Public-Subnet2 CIDR value"
}

variable "pub_sub3_cidr" {
  type        = string
  default = "10.10.2.0/24"
  description = "Public-Subnet3 CIDR value"
}

variable "pri_sub1_cidr" {
  type        = string
  default = "10.10.3.0/24"
  description = "Private-Subnet1 CIDR value"
}

variable "pri_sub2_cidr" {
  type        = string
  default = "10.10.4.0/24"
  description = "Private-Subnet2 CIDR value"
}

variable "pri_sub3_cidr" {
  type        = string
  default = "10.10.5.0/24"
  description = "Private-Subnet3 CIDR value"
}
