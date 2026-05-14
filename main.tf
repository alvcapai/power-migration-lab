# ==========================================
# Resource Group
# ==========================================

module "resource_group" {
  source = "./modules/resource_group"

  create_resource_group = var.create_resource_group
  resource_group_name   = local.resource_group_name
  tags                  = local.common_tags
}

# ==========================================
# Cloud Object Storage
# ==========================================

module "cos" {
  source = "./modules/cos"

  create_cos               = var.create_cos
  resource_group_id        = module.resource_group.resource_group_id
  cos_instance_name        = local.cos_instance_name
  cos_bucket_name          = local.cos_bucket_name
  cos_plan                 = var.cos_plan
  cos_bucket_storage_class = var.cos_bucket_storage_class
  region                   = var.region
  tags                     = local.common_tags
}

# ==========================================
# VPC Infrastructure
# ==========================================

module "vpc" {
  source = "./modules/vpc"

  create_vpc              = var.create_vpc
  resource_group_id       = module.resource_group.resource_group_id
  vpc_name                = local.vpc_name
  region                  = var.region
  zone                    = var.zone
  vpc_address_prefix_cidr = var.vpc_address_prefix_cidr
  vpc_subnet_cidr         = var.vpc_subnet_cidr
  security_group_rules    = local.security_group_rules
  tags                    = local.common_tags
}

# ==========================================
# Bastion/Staging VSI
# ==========================================

module "bastion" {
  source = "./modules/bastion"

  create_bastion         = var.create_bastion
  resource_group_id      = module.resource_group.resource_group_id
  bastion_name           = local.bastion_name
  vpc_id                 = module.vpc.vpc_id
  subnet_id              = module.vpc.subnet_id
  security_group_id      = module.vpc.security_group_id
  use_existing_ssh_key   = var.use_existing_ssh_key
  existing_ssh_key_name  = var.existing_ssh_key_name
  ssh_key_name           = local.ssh_key_name
  ssh_public_key         = var.ssh_public_key
  bastion_profile        = var.bastion_profile
  bastion_image          = var.bastion_image
  zone                   = var.zone
  tags                   = local.common_tags
}

# ==========================================
# PowerVS Workspace and AIX Instances
# ==========================================

module "powervs" {
  source = "./modules/powervs"

  resource_group_id             = module.resource_group.resource_group_id
  powervs_workspace_name        = local.powervs_workspace_name
  powervs_service_instance_name = local.powervs_service_instance_name
  powervs_datacenter            = var.powervs_datacenter
  powervs_zone                  = var.powervs_zone
  powervs_network_name          = local.powervs_network_name
  powervs_network_cidr          = var.powervs_network_cidr
  powervs_network_type          = var.powervs_network_type
  powervs_network_dns           = var.powervs_network_dns
  powervs_storage_pool          = var.powervs_storage_pool
  use_existing_ssh_key          = var.use_existing_ssh_key
  existing_ssh_key_name         = var.existing_ssh_key_name
  powervs_ssh_key_name          = local.powervs_ssh_key_name
  ssh_public_key                = var.ssh_public_key
  aix_image_name                = var.aix_image_name
  aix_source_name               = local.aix_source_name
  aix_source_processors         = var.aix_source_processors
  aix_source_memory             = var.aix_source_memory
  aix_source_proc_type          = var.aix_source_proc_type
  aix_source_sys_type           = var.aix_source_sys_type
  aix_target_name               = local.aix_target_name
  aix_target_processors         = var.aix_target_processors
  aix_target_memory             = var.aix_target_memory
  aix_target_proc_type          = var.aix_target_proc_type
  aix_target_sys_type           = var.aix_target_sys_type
  aix_nim_name                  = local.aix_nim_name
  aix_nim_processors            = var.aix_nim_processors
  aix_nim_memory                = var.aix_nim_memory
  aix_nim_proc_type             = var.aix_nim_proc_type
  aix_nim_sys_type              = var.aix_nim_sys_type
  source_data_volume_name       = local.source_data_volume_name
  source_data_volume_size       = var.source_data_volume_size
  target_data_volume_name       = local.target_data_volume_name
  target_data_volume_size       = var.target_data_volume_size
  nim_data_volume_name          = local.nim_data_volume_name
  nim_data_volume_size          = var.nim_data_volume_size
  create_nim                    = var.create_nim
  tags                          = local.common_tags
}