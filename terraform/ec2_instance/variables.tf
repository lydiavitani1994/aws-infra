variable "security_group_id" {
  type = string
  description = "security_group_id"
}

variable "public_subnet_ids" {
  type = list(string)
  description = "public_subnet_ids"
}

variable "associate_public_ip_address" {
  type = bool
  default = true
  description = "associate_public_ip_address"
}

variable "tag_name" {
  type = string
  default = "aws_linux_2_instance"
  description = "tag_name"
}

variable "instance_type" {
  type = string
  default = "t2.micro"
  description = "instance_type"
}

variable "disable_api_termination" {
  type = bool
  default = false
  description = "disable_api_termination"
}
variable "volume_size" {
  type = number
  default = 50
  description = "volume_size"
}
variable "volume_type" {
  type = string
  default = "gp2"
  description = "volume_type"
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
