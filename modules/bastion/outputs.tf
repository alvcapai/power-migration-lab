output "bastion_id" {
  description = "ID of the bastion VSI"
  value       = local.bastion_id
}

output "bastion_name" {
  description = "Name of the bastion VSI"
  value       = local.bastion_name
}

output "bastion_public_ip" {
  description = "Public IP address of the bastion VSI"
  value       = local.bastion_public_ip
}

output "bastion_private_ip" {
  description = "Private IP address of the bastion VSI"
  value       = local.bastion_private_ip
}