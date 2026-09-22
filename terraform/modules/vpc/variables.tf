variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
}

variable "environment" {
  description = "Ambiente: dev, qa o prod"
  type        = string
}

variable "vpc_cidr" {
  description = "Rango de direcciones IP de la VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDRs de las subnets publicas"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDRs de las subnets privadas"
  type        = list(string)
}

variable "availability_zones" {
  description = "Zonas de disponibilidad de AWS"
  type        = list(string)
}