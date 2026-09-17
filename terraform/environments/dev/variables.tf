variable "aws_region" {
  description = "Region AWS"
  type        = string
}

variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
}

variable "environment" {
  description = "Ambiente"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR de la VPC"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR subnet publica"
  type        = string
}

variable "private_subnet_cidr" {
  description = "CIDR subnet privada"
  type        = string
}

variable "availability_zone" {
  description = "Availability Zone"
  type        = string
}