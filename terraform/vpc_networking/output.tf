output "vpc" {
  value = aws_vpc.vpc
}

output "public_subnet_ids" {
  value = local.public_subnet_ids
}

output "private_subnet_ids" {
  value = local.private_subnet_ids
}

output "unique_public_subnet_id_az" {
  value = local.unique_public_subnet_id_az
}
