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

variable "public_subnet_cidr" {
  description = "CIDR de la subnet publica"
  type        = string
}

variable "private_subnet_cidr" {
  description = "CIDR de la subnet privada"
  type        = string
}

variable "availability_zone" {
  description = "Zona de disponibilidad de AWS"
  type        = string
}