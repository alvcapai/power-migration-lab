# ==========================================
# PowerVS Workspace (Service Instance)
# ==========================================

resource "ibm_resource_instance" "powervs_workspace" {
  name              = var.powervs_service_instance_name
  service           = "power-iaas"
  plan              = "power-virtual-server-group"
  location          = var.powervs_datacenter
  resource_group_id = var.resource_group_id
  tags              = var.tags

  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
}

# ==========================================
# PowerVS SSH Key
# ==========================================

resource "ibm_pi_key" "ssh_key" {
  pi_cloud_instance_id = ibm_resource_instance.powervs_workspace.guid
  pi_key_name          = var.powervs_ssh_key_name
  pi_ssh_key           = var.ssh_public_key
}

# ==========================================
# PowerVS Private Network
# ==========================================

resource "ibm_pi_network" "private_network" {
  pi_cloud_instance_id = ibm_resource_instance.powervs_workspace.guid
  pi_network_name      = var.powervs_network_name
  pi_network_type      = var.powervs_network_type
  pi_cidr              = var.powervs_network_cidr
  pi_dns               = var.powervs_network_dns
}

# ==========================================
# Data Source for AIX Image
# ==========================================

data "ibm_pi_image" "aix_image" {
  pi_cloud_instance_id = ibm_resource_instance.powervs_workspace.guid
  pi_image_name        = var.aix_image_name
}

# ==========================================
# AIX Source Instance
# ==========================================

resource "ibm_pi_instance" "aix_source" {
  pi_cloud_instance_id = ibm_resource_instance.powervs_workspace.guid
  pi_instance_name     = var.aix_source_name
  pi_image_id          = data.ibm_pi_image.aix_image.id
  pi_memory            = var.aix_source_memory
  pi_processors        = var.aix_source_processors
  pi_proc_type         = var.aix_source_proc_type
  pi_sys_type          = var.aix_source_sys_type
  pi_storage_pool      = var.powervs_storage_pool
  pi_key_pair_name     = ibm_pi_key.ssh_key.pi_key_name

  pi_network {
    network_id = ibm_pi_network.private_network.network_id
  }

  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
}

# ==========================================
# AIX Source Data Volume
# ==========================================

resource "ibm_pi_volume" "source_data_volume" {
  pi_cloud_instance_id = ibm_resource_instance.powervs_workspace.guid
  pi_volume_name       = var.source_data_volume_name
  pi_volume_size       = var.source_data_volume_size
  pi_volume_shareable  = false
  pi_volume_pool       = var.powervs_storage_pool
}

resource "ibm_pi_volume_attach" "source_data_attach" {
  pi_cloud_instance_id = ibm_resource_instance.powervs_workspace.guid
  pi_instance_id       = ibm_pi_instance.aix_source.instance_id
  pi_volume_id         = ibm_pi_volume.source_data_volume.volume_id
}

# ==========================================
# AIX Target Instance
# ==========================================

resource "ibm_pi_instance" "aix_target" {
  pi_cloud_instance_id = ibm_resource_instance.powervs_workspace.guid
  pi_instance_name     = var.aix_target_name
  pi_image_id          = data.ibm_pi_image.aix_image.id
  pi_memory            = var.aix_target_memory
  pi_processors        = var.aix_target_processors
  pi_proc_type         = var.aix_target_proc_type
  pi_sys_type          = var.aix_target_sys_type
  pi_storage_pool      = var.powervs_storage_pool
  pi_key_pair_name     = ibm_pi_key.ssh_key.pi_key_name

  pi_network {
    network_id = ibm_pi_network.private_network.network_id
  }

  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
}

# ==========================================
# AIX Target Data Volume
# ==========================================

resource "ibm_pi_volume" "target_data_volume" {
  pi_cloud_instance_id = ibm_resource_instance.powervs_workspace.guid
  pi_volume_name       = var.target_data_volume_name
  pi_volume_size       = var.target_data_volume_size
  pi_volume_shareable  = false
  pi_volume_pool       = var.powervs_storage_pool
}

resource "ibm_pi_volume_attach" "target_data_attach" {
  pi_cloud_instance_id = ibm_resource_instance.powervs_workspace.guid
  pi_instance_id       = ibm_pi_instance.aix_target.instance_id
  pi_volume_id         = ibm_pi_volume.target_data_volume.volume_id
}

# ==========================================
# AIX NIM Instance (Optional)
# ==========================================

resource "ibm_pi_instance" "aix_nim" {
  count                = var.create_nim ? 1 : 0
  pi_cloud_instance_id = ibm_resource_instance.powervs_workspace.guid
  pi_instance_name     = var.aix_nim_name
  pi_image_id          = data.ibm_pi_image.aix_image.id
  pi_memory            = var.aix_nim_memory
  pi_processors        = var.aix_nim_processors
  pi_proc_type         = var.aix_nim_proc_type
  pi_sys_type          = var.aix_nim_sys_type
  pi_storage_pool      = var.powervs_storage_pool
  pi_key_pair_name     = ibm_pi_key.ssh_key.pi_key_name

  pi_network {
    network_id = ibm_pi_network.private_network.network_id
  }

  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
}

# ==========================================
# AIX NIM Data Volume (Optional)
# ==========================================

resource "ibm_pi_volume" "nim_data_volume" {
  count                = var.create_nim ? 1 : 0
  pi_cloud_instance_id = ibm_resource_instance.powervs_workspace.guid
  pi_volume_name       = var.nim_data_volume_name
  pi_volume_size       = var.nim_data_volume_size
  pi_volume_shareable  = false
  pi_volume_pool       = var.powervs_storage_pool
}

resource "ibm_pi_volume_attach" "nim_data_attach" {
  count                = var.create_nim ? 1 : 0
  pi_cloud_instance_id = ibm_resource_instance.powervs_workspace.guid
  pi_instance_id       = ibm_pi_instance.aix_nim[0].instance_id
  pi_volume_id         = ibm_pi_volume.nim_data_volume[0].volume_id
}

# ==========================================
# Locals
# ==========================================

locals {
  powervs_workspace_id   = ibm_resource_instance.powervs_workspace.id
  powervs_workspace_guid = ibm_resource_instance.powervs_workspace.guid
  powervs_workspace_name = ibm_resource_instance.powervs_workspace.name
  powervs_workspace_crn  = ibm_resource_instance.powervs_workspace.crn
  powervs_network_id     = ibm_pi_network.private_network.network_id
  powervs_network_name   = ibm_pi_network.private_network.pi_network_name

  # AIX Source
  aix_source_id              = ibm_pi_instance.aix_source.instance_id
  aix_source_name            = ibm_pi_instance.aix_source.pi_instance_name
  aix_source_private_ip      = ibm_pi_instance.aix_source.pi_network[0].ip_address
  aix_source_data_volume_id  = ibm_pi_volume.source_data_volume.volume_id
  aix_source_data_volume_name = ibm_pi_volume.source_data_volume.pi_volume_name

  # AIX Target
  aix_target_id              = ibm_pi_instance.aix_target.instance_id
  aix_target_name            = ibm_pi_instance.aix_target.pi_instance_name
  aix_target_private_ip      = ibm_pi_instance.aix_target.pi_network[0].ip_address
  aix_target_data_volume_id  = ibm_pi_volume.target_data_volume.volume_id
  aix_target_data_volume_name = ibm_pi_volume.target_data_volume.pi_volume_name

  # AIX NIM (Optional)
  aix_nim_id              = var.create_nim ? ibm_pi_instance.aix_nim[0].instance_id : null
  aix_nim_name            = var.create_nim ? ibm_pi_instance.aix_nim[0].pi_instance_name : null
  aix_nim_private_ip      = var.create_nim ? ibm_pi_instance.aix_nim[0].pi_network[0].ip_address : null
  aix_nim_data_volume_id  = var.create_nim ? ibm_pi_volume.nim_data_volume[0].volume_id : null
  aix_nim_data_volume_name = var.create_nim ? ibm_pi_volume.nim_data_volume[0].pi_volume_name : null
}