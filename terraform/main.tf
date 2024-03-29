# version
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0, <5.0"
    }
  }
  required_version = ">= 1.2.0"
}

# provider
provider "aws" {
  region  = var.provider_region
  profile = var.provider_profile
}

# vpc
module "vpc" {
  source = "./vpc_networking"

  vpc_cidr     = var.vpc_cidr_block
  vpc_tag_name = var.vpc_tag_name
}

module "load_balancer_security_group" {
  source = "./load_balancer_security_group"

  vpc_id = module.vpc.vpc.id
  destination_security_group_id = module.application_security_group.security_group.id
}

module "application_security_group" {
  source = "./application_security_group"

  source_security_group_id = module.load_balancer_security_group.security_group.id
  vpc_id                   = module.vpc.vpc.id
  destination_security_group_id = module.database_security_group.security_group.id
}

module "database_security_group" {
  source = "./database_security_group"

  source_security_group_id = module.application_security_group.security_group.id
  vpc_id                   = module.vpc.vpc.id
}



module "s3_bucket" {
  source = "./s3_bucket"
}

module "db_parameter_group" {
  source = "./db_parameter_group"
}

module "rds_instance" {
  source = "./rds_instance"

  private_subnet_ids   = module.vpc.private_subnet_ids
  parameter_group_name = module.db_parameter_group.db_parameter_group.name
  security_group_id    = module.database_security_group.security_group.id
}

module "iam_role" {
  source = "./iam_role"

  s3_bucket_name = module.s3_bucket.s3_bucket.bucket
}

# module "ec2_instance" {
#   source = "./ec2_instance"

#   # filter_id = var.ami_id
#   public_subnet_ids    = module.vpc.public_subnet_ids
#   security_group_id    = module.application_security_group.security_group.id
#   db_username          = module.rds_instance.db_instance.username
#   db_password          = module.rds_instance.db_instance.password
#   db_hostname          = module.rds_instance.db_instance.address
#   s3_bucket_name       = module.s3_bucket.s3_bucket.bucket
#   iam_instance_profile = module.iam_role.iam_instance_profile.name
#   # s3_access_key = module.iam_role.access_key_id
#   # s3_secret_access = module.iam_role.secret_access_key
#   region       = var.provider_region
#   profile_name = var.provider_profile
# }

module "auto_scaling" {
  source = "./auto_scaling"

  app_security_group_id      = module.application_security_group.security_group.id
  lb_security_group_id       = module.load_balancer_security_group.security_group.id
  db_username                = module.rds_instance.db_instance.username
  db_password                = module.rds_instance.db_instance.password
  db_hostname                = module.rds_instance.db_instance.address
  s3_bucket_name             = module.s3_bucket.s3_bucket.bucket
  iam_instance_profile       = module.iam_role.iam_instance_profile.name
  region                     = var.provider_region
  public_subnet_ids          = module.vpc.public_subnet_ids
  vpc_id                     = module.vpc.vpc.id
  unique_public_subnet_id_az = module.vpc.unique_public_subnet_id_az
  profile_name               = var.provider_profile
  iam_role_arn = module.iam_role.iam_role.arn
}
