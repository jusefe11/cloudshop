output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "IDs de las subnets publicas"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs de las subnets privadas"
  value       = module.vpc.private_subnet_ids
}

output "security_group_id" {
  value = module.vpc.security_group_id
}

output "ecr_repository_urls" {
  description = "URLs de los repositorios ECR de CloudShop"
  value       = module.ecr.repository_urls
}