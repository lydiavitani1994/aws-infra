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

  vpc_cidr = var.vpc_cidr_block
  vpc_tag_name     = var.vpc_tag_name
}

module "security_group" {
  source = "./security_group"

  # vpc_cidr_block = var.vpc_cidr_block
  vpc_id = module.vpc.vpc.id
  # aws_vpc = module.provider.vpc
}

module "ec2_instance" {
  source = "./ec2_instance"

  # filter_id = var.ami_id
  public_subnet_ids = module.vpc.public_subnet_ids
  security_group_id = module.security_group.security_group.id
}



