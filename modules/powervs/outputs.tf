# PowerVS Workspace Outputs
output "powervs_workspace_id" {
  description = "ID of the PowerVS workspace"
  value       = local.powervs_workspace_id
}

output "powervs_workspace_guid" {
  description = "GUID of the PowerVS workspace"
  value       = local.powervs_workspace_guid
}

output "powervs_workspace_name" {
  description = "Name of the PowerVS workspace"
  value       = local.powervs_workspace_name
}

output "powervs_workspace_crn" {
  description = "CRN of the PowerVS workspace"
  value       = local.powervs_workspace_crn
}

output "powervs_network_id" {
  description = "ID of the PowerVS private network"
  value       = local.powervs_network_id
}

output "powervs_network_name" {
  description = "Name of the PowerVS private network"
  value       = local.powervs_network_name
}

# AIX Source Outputs
output "aix_source_id" {
  description = "ID of the AIX source instance"
  value       = local.aix_source_id
}

output "aix_source_name" {
  description = "Name of the AIX source instance"
  value       = local.aix_source_name
}

output "aix_source_private_ip" {
  description = "Private IP of the AIX source instance"
  value       = local.aix_source_private_ip
}

output "aix_source_data_volume_id" {
  description = "ID of the AIX source data volume"
  value       = local.aix_source_data_volume_id
}

output "aix_source_data_volume_name" {
  description = "Name of the AIX source data volume"
  value       = local.aix_source_data_volume_name
}

# AIX Target Outputs
output "aix_target_id" {
  description = "ID of the AIX target instance"
  value       = local.aix_target_id
}

output "aix_target_name" {
  description = "Name of the AIX target instance"
  value       = local.aix_target_name
}

output "aix_target_private_ip" {
  description = "Private IP of the AIX target instance"
  value       = local.aix_target_private_ip
}

output "aix_target_data_volume_id" {
  description = "ID of the AIX target data volume"
  value       = local.aix_target_data_volume_id
}

output "aix_target_data_volume_name" {
  description = "Name of the AIX target data volume"
  value       = local.aix_target_data_volume_name
}

# AIX NIM Outputs (Optional)
output "aix_nim_id" {
  description = "ID of the AIX NIM instance"
  value       = local.aix_nim_id
}

output "aix_nim_name" {
  description = "Name of the AIX NIM instance"
  value       = local.aix_nim_name
}

output "aix_nim_private_ip" {
  description = "Private IP of the AIX NIM instance"
  value       = local.aix_nim_private_ip
}

output "aix_nim_data_volume_id" {
  description = "ID of the AIX NIM data volume"
  value       = local.aix_nim_data_volume_id
}

output "aix_nim_data_volume_name" {
  description = "Name of the AIX NIM data volume"
  value       = local.aix_nim_data_volume_name
}