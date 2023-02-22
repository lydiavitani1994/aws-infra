output "vpc" {
  value = aws_vpc.vpc
}

output "public_subnet_ids" {
  value = local.public_subnet_ids
}