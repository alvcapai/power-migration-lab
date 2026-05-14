# ==========================================
# Resource Group Outputs
# ==========================================

output "resource_group_id" {
  description = "ID of the resource group"
  value       = module.resource_group.resource_group_id
}

output "resource_group_name" {
  description = "Name of the resource group"
  value       = module.resource_group.resource_group_name
}

# ==========================================
# Cloud Object Storage Outputs
# ==========================================

output "cos_instance_id" {
  description = "ID of the Cloud Object Storage instance"
  value       = module.cos.cos_instance_id
}

output "cos_instance_crn" {
  description = "CRN of the Cloud Object Storage instance"
  value       = module.cos.cos_instance_crn
}

output "cos_bucket_name" {
  description = "Name of the COS bucket for migration artifacts"
  value       = module.cos.cos_bucket_name
}

output "cos_bucket_region" {
  description = "Region of the COS bucket"
  value       = module.cos.cos_bucket_region
}

# ==========================================
# VPC Outputs
# ==========================================

output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_name" {
  description = "Name of the VPC"
  value       = module.vpc.vpc_name
}

output "vpc_subnet_id" {
  description = "ID of the VPC subnet"
  value       = module.vpc.subnet_id
}

output "vpc_subnet_cidr" {
  description = "CIDR block of the VPC subnet"
  value       = module.vpc.subnet_cidr
}

output "vpc_security_group_id" {
  description = "ID of the VPC security group"
  value       = module.vpc.security_group_id
}

# ==========================================
# Bastion Outputs
# ==========================================

output "bastion_id" {
  description = "ID of the bastion VSI"
  value       = module.bastion.bastion_id
}

output "bastion_name" {
  description = "Name of the bastion VSI"
  value       = module.bastion.bastion_name
}

output "bastion_public_ip" {
  description = "Public IP address of the bastion VSI"
  value       = module.bastion.bastion_public_ip
}

output "bastion_private_ip" {
  description = "Private IP address of the bastion VSI"
  value       = module.bastion.bastion_private_ip
}

# ==========================================
# PowerVS Workspace Outputs
# ==========================================

output "powervs_workspace_id" {
  description = "ID of the PowerVS workspace"
  value       = module.powervs.powervs_workspace_id
}

output "powervs_workspace_name" {
  description = "Name of the PowerVS workspace"
  value       = module.powervs.powervs_workspace_name
}

output "powervs_workspace_crn" {
  description = "CRN of the PowerVS workspace"
  value       = module.powervs.powervs_workspace_crn
}

output "powervs_network_id" {
  description = "ID of the PowerVS private network"
  value       = module.powervs.powervs_network_id
}

output "powervs_network_name" {
  description = "Name of the PowerVS private network"
  value       = module.powervs.powervs_network_name
}

# ==========================================
# AIX Source Instance Outputs
# ==========================================

output "aix_source_id" {
  description = "ID of the AIX source instance"
  value       = module.powervs.aix_source_id
}

output "aix_source_name" {
  description = "Name of the AIX source instance"
  value       = module.powervs.aix_source_name
}

output "aix_source_private_ip" {
  description = "Private IP address of the AIX source instance"
  value       = module.powervs.aix_source_private_ip
}

output "aix_source_data_volume_id" {
  description = "ID of the AIX source data volume"
  value       = module.powervs.aix_source_data_volume_id
}

output "aix_source_data_volume_name" {
  description = "Name of the AIX source data volume"
  value       = module.powervs.aix_source_data_volume_name
}

# ==========================================
# AIX Target Instance Outputs
# ==========================================

output "aix_target_id" {
  description = "ID of the AIX target instance"
  value       = module.powervs.aix_target_id
}

output "aix_target_name" {
  description = "Name of the AIX target instance"
  value       = module.powervs.aix_target_name
}

output "aix_target_private_ip" {
  description = "Private IP address of the AIX target instance"
  value       = module.powervs.aix_target_private_ip
}

output "aix_target_data_volume_id" {
  description = "ID of the AIX target data volume"
  value       = module.powervs.aix_target_data_volume_id
}

output "aix_target_data_volume_name" {
  description = "Name of the AIX target data volume"
  value       = module.powervs.aix_target_data_volume_name
}

# ==========================================
# AIX NIM Instance Outputs (Optional)
# ==========================================

output "aix_nim_id" {
  description = "ID of the AIX NIM instance (if created)"
  value       = module.powervs.aix_nim_id
}

output "aix_nim_name" {
  description = "Name of the AIX NIM instance (if created)"
  value       = module.powervs.aix_nim_name
}

output "aix_nim_private_ip" {
  description = "Private IP address of the AIX NIM instance (if created)"
  value       = module.powervs.aix_nim_private_ip
}

output "aix_nim_data_volume_id" {
  description = "ID of the AIX NIM data volume (if created)"
  value       = module.powervs.aix_nim_data_volume_id
}

output "aix_nim_data_volume_name" {
  description = "Name of the AIX NIM data volume (if created)"
  value       = module.powervs.aix_nim_data_volume_name
}

# ==========================================
# Ansible Inventory Output
# ==========================================

output "ansible_inventory" {
  description = "Structured data for Ansible inventory generation"
  value = {
    bastion = {
      host = module.bastion.bastion_public_ip
      user = "root"
      name = module.bastion.bastion_name
    }
    aix_source = {
      host = module.powervs.aix_source_private_ip
      user = "root"
      name = module.powervs.aix_source_name
    }
    aix_target = {
      host = module.powervs.aix_target_private_ip
      user = "root"
      name = module.powervs.aix_target_name
    }
    aix_nim = var.create_nim ? {
      host = module.powervs.aix_nim_private_ip
      user = "root"
      name = module.powervs.aix_nim_name
    } : null
    cos = {
      bucket        = module.cos.cos_bucket_name
      instance_id   = module.cos.cos_instance_id
      instance_crn  = module.cos.cos_instance_crn
      region        = module.cos.cos_bucket_region
    }
    powervs = {
      workspace_id   = module.powervs.powervs_workspace_id
      workspace_name = module.powervs.powervs_workspace_name
      network_id     = module.powervs.powervs_network_id
      network_name   = module.powervs.powervs_network_name
    }
    volumes = {
      source_data = {
        id   = module.powervs.aix_source_data_volume_id
        name = module.powervs.aix_source_data_volume_name
      }
      target_data = {
        id   = module.powervs.aix_target_data_volume_id
        name = module.powervs.aix_target_data_volume_name
      }
      nim_data = var.create_nim ? {
        id   = module.powervs.aix_nim_data_volume_id
        name = module.powervs.aix_nim_data_volume_name
      } : null
    }
  }
}

# ==========================================
# Summary Output
# ==========================================

output "deployment_summary" {
  description = "Summary of deployed resources"
  value = {
    resource_group = module.resource_group.resource_group_name
    region         = var.region
    zone           = var.zone
    vpc_name       = module.vpc.vpc_name
    bastion_ip     = module.bastion.bastion_public_ip
    powervs_workspace = module.powervs.powervs_workspace_name
    aix_instances = {
      source = {
        name = module.powervs.aix_source_name
        ip   = module.powervs.aix_source_private_ip
      }
      target = {
        name = module.powervs.aix_target_name
        ip   = module.powervs.aix_target_private_ip
      }
      nim = var.create_nim ? {
        name = module.powervs.aix_nim_name
        ip   = module.powervs.aix_nim_private_ip
      } : null
    }
    cos_bucket = module.cos.cos_bucket_name
  }
}