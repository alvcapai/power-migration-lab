output "vpc_id" {
  description = "ID of the VPC"
  value       = local.vpc_id
}

output "vpc_name" {
  description = "Name of the VPC"
  value       = local.vpc_name
}

output "subnet_id" {
  description = "ID of the VPC subnet"
  value       = local.subnet_id
}

output "subnet_cidr" {
  description = "CIDR block of the VPC subnet"
  value       = local.subnet_cidr
}

output "security_group_id" {
  description = "ID of the security group"
  value       = local.security_group_id
}