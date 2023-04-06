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

variable "instance_type" {
  type = string
  description = "instance_type"
  default = "t2.micro"
}
variable "key_name" {
  type = string
  description = "key_name"
  default = "ec2"
}

variable "associate_public_ip_address" {
  type = bool
  default = true
  description = "associate_public_ip_address"
}

variable "delete_on_termination" {
  type = bool
  default = true
  description = "delete_on_termination"
}

variable "lb_name" {
  type = string
  description = "lb_name"
  default = "csye6225-lb"
}

variable "load_balancer_type" {
  type = string
  description = "load_balancer_type"
  default = "application"
}

variable "lb_target_group_name" {
  type = string
  description = "lb_target_group_name"
  default = "lb-tg"
}

variable "app_port" {
  type = number
  description = "app_port"
  default = 8080
}

variable "protocol" {
  type = string
  description = "protocol"
  default = "HTTP"
}

variable "adjustment_type" {
  type = string
  description = "adjustment_type"
  default = "ChangeInCapacity"
}

variable "metric_name" {
  type = string
  description = "metric_name"
  default = "CPUUtilization"
}

