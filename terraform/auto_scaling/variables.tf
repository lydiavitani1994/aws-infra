variable "app_security_group_id" {
  type = string
  description = "app_security_group_id"
}

variable "lb_security_group_id" {
  type = string
  description = "lb_security_group_id"
}

variable "db_username" {
  type = string
  description = "db_username"
}

variable "db_password" {
  type = string
  description = "db_password"
}

variable "db_hostname" {
  type = string
  description = "db_hostname"
}

variable "s3_bucket_name" {
  type = string
  description = "s3_bucket_name"
}

variable "iam_instance_profile" {
  type = string
  description = "iam_instance_profile_name"
}


variable "region" {
  type = string
  description = "region"
}

variable "namespace" {
  type = string
  description = "namespace"
  default = "webapp"
}

variable "cloudwatch_config_path" {
  type = string
  description = "cloudwatch_config_path"
  default = "/opt/deployment/cloudwatch_config.json"
}

variable "filter_most_recent" {
  type = bool
  default = true
  description = "filter_most_recent"
}

# variable "filter_id" {
#   type = string
#   description = "filter_id"
# }

variable "filter_name_value" {
  type = string
  default = "yumeng_*"
  description = "filter_name_value"
}

variable "filter_device_type_value" {
  type = string
  default = "ebs"
  description = "filter_device_type_value"
}

variable "filter_virtualization_type_value" {
  type = string
  default = "hvm"
  description = "filter_virtualization_type_value"
}

variable "public_subnet_ids" {
  type = list(string)
  description = "public_subnet_ids"
}

variable "unique_public_subnet_id_az" {
  type = list(string)
  description = "unique_public_subnet_id_az"
}

variable "vpc_id" {
  type = string
  description = "vpc_id"
}

variable "profile_name" {
  type = string
  description = "profile_name"
}

variable "domain" {
  type = string
  description = "domain"
  default = "yumenghuang.me"
}

variable "private_zone" {
  type = bool
  description = "private_zone"
  default = false
}

