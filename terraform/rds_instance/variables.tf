variable "private_subnet_ids" {
  type = list(string)
  description = "private_subnet_ids"
}

variable "parameter_group_name" {
  type = string
  description = "parameter_group_name"
}

variable "security_group_id" {
  type = string
  description = "security_group_id"
}

variable "allocated_storage" {
  type        = number
  description = "allocated_storage"
  default = 10
}

variable "backup_retention_period" {
  type        = number
  description = "backup_retention_period"
  default = 0
}

variable "apply_immediately" {
  type        = bool
  description = "apply_immediately"
  default = true
}

variable "skip_final_snapshot" {
  type        = bool
  description = "skip_final_snapshot"
  default = true
}

variable "private_subnet_group_name" {
  type        = string
  description = "private_subnet_group_name"
  default = "private_subnet_group"
}

variable "private_subnet_group_tag_name" {
  type        = string
  description = "private_subnet_group_tag_name"
  default = "private_subnet_group"
}

variable "engine" {
  type        = string
  description = "engine"
  default = "postgres"
}

variable "engine_version" {
  type        = string
  description = "engine_version"
  default = "15"
}

variable "instance_class" {
  type        = string
  description = "instance_class"
  default = "db.t3.micro"
}

variable "multi_az" {
  type        = bool
  description = "multi_az"
  default = false
}

variable "identifier" {
  type        = string
  description = "identifier"
  default = "csye6225"
}

variable "username" {
  type        = string
  description = "username"
  default = "csye6225"
}

variable "password" {
  type        = string
  description = "password"
  default = "csye6225password"
}

variable "db_name" {
  type        = string
  description = "db_name"
  default = "csye6225"
}

variable "publicly_accessible" {
  type        = bool
  description = "publicly_accessible"
  default = false
}
