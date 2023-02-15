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
module "dev_provider" {
  source = "./vpc_networking"

  provider_region  = var.provider_region
  provider_profile = var.provider_profile
  vpc_tag_name     = var.vpc_tag_name
}

