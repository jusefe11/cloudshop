output "repository_urls" {
  description = "URLs de los repositorios ECR creados"

  value = {
    for name, repo in aws_ecr_repository.repositories :
    name => repo.repository_url
  }
}