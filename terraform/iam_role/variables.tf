variable "s3_bucket_name" {
  type        = string
  description = "s3_bucket_name"
}

variable "s3_policy_name" {
  type        = string
  description = "s3_policy_name"
  default = "WebAppS3"
}

variable "ec2_policy_name" {
  type        = string
  description = "ec2_policy_name"
  default = "WebAppEC2"
}

variable "iam_role_name" {
  type        = string
  description = "iam_role_name"
  default = "EC2-CSYE6225"
}

variable "pgp_key" {
  type        = string
  description = "pgp_key"
  default = "keybase:some_person_that_exists"
}
