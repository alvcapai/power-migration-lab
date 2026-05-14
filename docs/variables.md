# Variables Documentation

This document provides detailed information about all Terraform variables used in this project.

## Table of Contents

- [IBM Cloud Authentication](#ibm-cloud-authentication)
- [General Configuration](#general-configuration)
- [SSH Configuration](#ssh-configuration)
- [Cloud Object Storage Configuration](#cloud-object-storage-configuration)
- [VPC Configuration](#vpc-configuration)
- [Bastion Configuration](#bastion-configuration)
- [PowerVS Workspace Configuration](#powervs-workspace-configuration)
- [AIX Configuration](#aix-configuration)
- [Storage Configuration](#storage-configuration)
- [Feature Flags](#feature-flags)

## IBM Cloud Authentication

### `ibmcloud_api_key`
- **Type**: `string`
- **Required**: Yes
- **Sensitive**: Yes
- **Description**: IBM Cloud API Key for authentication
- **How to obtain**:
  ```bash
  ibmcloud login
  ibmcloud iam api-key-create power-migration-lab-key -d "Key for Power Migration Lab"
  ```
- **Security**: Never commit this value to version control

## General Configuration

### `region`
- **Type**: `string`
- **Required**: No
- **Default**: `"us-south"`
- **Description**: IBM Cloud region for VPC resources
- **Valid values**: 
  - `us-south` (Dallas)
  - `us-east` (Washington DC)
  - `eu-de` (Frankfurt)
  - `eu-gb` (London)
  - `jp-tok` (Tokyo)
  - `au-syd` (Sydney)
  - `jp-osa` (Osaka)
  - `ca-tor` (Toronto)
  - `br-sao` (São Paulo)
- **Example**: `"us-south"`

### `zone`
- **Type**: `string`
- **Required**: No
- **Default**: `"us-south-1"`
- **Description**: IBM Cloud zone for VPC resources
- **Valid values**: Depends on region (e.g., `us-south-1`, `us-south-2`, `us-south-3`)
- **Example**: `"us-south-1"`

### `resource_group_name`
- **Type**: `string`
- **Required**: No
- **Default**: `"power-migration-lab"`
- **Description**: Name of the IBM Cloud Resource Group to use or create
- **Example**: `"power-migration-lab"`

### `create_resource_group`
- **Type**: `bool`
- **Required**: No
- **Default**: `true`
- **Description**: Whether to create a new resource group (true) or use an existing one (false)
- **Example**: `true`

### `prefix`
- **Type**: `string`
- **Required**: No
- **Default**: `"pml"`
- **Description**: Prefix to add to all resource names for identification
- **Validation**: Must be lowercase alphanumeric with hyphens, start with a letter, max 10 characters
- **Example**: `"pml"`

### `tags`
- **Type**: `list(string)`
- **Required**: No
- **Default**: `["power-migration", "sandbox", "terraform"]`
- **Description**: List of tags to apply to all resources
- **Example**: `["power-migration", "sandbox", "terraform", "team:infrastructure"]`

## SSH Configuration

### `ssh_public_key`
- **Type**: `string`
- **Required**: Yes
- **Description**: SSH public key content for accessing instances
- **How to obtain**:
  ```bash
  cat ~/.ssh/id_rsa.pub
  ```
- **Example**: `"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC... user@example.com"`

### `allowed_ssh_cidr`
- **Type**: `string`
- **Required**: No
- **Default**: `"0.0.0.0/0"`
- **Description**: CIDR block allowed to SSH into bastion
- **Security**: Restrict to your IP in production (e.g., `"203.0.113.0/32"`)
- **Example**: `"203.0.113.0/32"`

## Cloud Object Storage Configuration

### `create_cos`
- **Type**: `bool`
- **Required**: No
- **Default**: `true`
- **Description**: Whether to create a new Cloud Object Storage instance
- **Example**: `true`

### `cos_instance_name`
- **Type**: `string`
- **Required**: No
- **Default**: `"migration-artifacts"`
- **Description**: Name for the Cloud Object Storage instance
- **Example**: `"migration-artifacts"`

### `cos_bucket_name`
- **Type**: `string`
- **Required**: No
- **Default**: `"migration-artifacts"`
- **Description**: Name for the COS bucket to store migration artifacts
- **Note**: A random suffix will be added to ensure global uniqueness
- **Example**: `"migration-artifacts"`

### `cos_plan`
- **Type**: `string`
- **Required**: No
- **Default**: `"standard"`
- **Description**: Service plan for Cloud Object Storage
- **Valid values**: `"standard"`, `"lite"`
- **Example**: `"standard"`

### `cos_bucket_storage_class`
- **Type**: `string`
- **Required**: No
- **Default**: `"standard"`
- **Description**: Storage class for COS bucket
- **Valid values**: `"standard"`, `"vault"`, `"cold"`, `"smart"`
- **Example**: `"standard"`

## VPC Configuration

### `create_vpc`
- **Type**: `bool`
- **Required**: No
- **Default**: `true`
- **Description**: Whether to create a new VPC
- **Example**: `true`

### `vpc_name`
- **Type**: `string`
- **Required**: No
- **Default**: `"sandbox"`
- **Description**: Name for the VPC
- **Example**: `"sandbox"`

### `vpc_subnet_cidr`
- **Type**: `string`
- **Required**: No
- **Default**: `"10.240.0.0/24"`
- **Description**: CIDR block for the VPC subnet
- **Example**: `"10.240.0.0/24"`

### `vpc_address_prefix_cidr`
- **Type**: `string`
- **Required**: No
- **Default**: `"10.240.0.0/16"`
- **Description**: CIDR block for the VPC address prefix
- **Example**: `"10.240.0.0/16"`

## Bastion Configuration

### `create_bastion`
- **Type**: `bool`
- **Required**: No
- **Default**: `true`
- **Description**: Whether to create a bastion/staging VSI
- **Example**: `true`

### `bastion_name`
- **Type**: `string`
- **Required**: No
- **Default**: `"bastion"`
- **Description**: Name for the bastion/staging VSI
- **Example**: `"bastion"`

### `bastion_profile`
- **Type**: `string`
- **Required**: No
- **Default**: `"cx2-2x4"`
- **Description**: Profile for the bastion VSI
- **Valid values**: Any valid VPC instance profile (e.g., `cx2-2x4`, `bx2-4x16`)
- **Example**: `"cx2-2x4"` (2 vCPUs, 4GB RAM)

### `bastion_image`
- **Type**: `string`
- **Required**: No
- **Default**: `"ibm-ubuntu-22-04-3-minimal-amd64-1"`
- **Description**: Image name for the bastion VSI
- **How to find available images**:
  ```bash
  ibmcloud is images --visibility public | grep ubuntu
  ```
- **Example**: `"ibm-ubuntu-22-04-3-minimal-amd64-1"`

## PowerVS Workspace Configuration

### `powervs_workspace_name`
- **Type**: `string`
- **Required**: No
- **Default**: `"migration-lab"`
- **Description**: Name for the PowerVS workspace
- **Example**: `"migration-lab"`

### `powervs_service_instance_name`
- **Type**: `string`
- **Required**: No
- **Default**: `"migration-lab"`
- **Description**: Name for the PowerVS service instance
- **Example**: `"migration-lab"`

### `powervs_datacenter`
- **Type**: `string`
- **Required**: No
- **Default**: `"dal12"`
- **Description**: PowerVS datacenter location
- **Valid values**:
  - US: `dal12`, `dal13`, `us-east`
  - Europe: `lon04`, `lon06`, `fra04`, `fra05`
  - Asia Pacific: `syd04`, `syd05`, `tok04`
  - Canada: `mon01`, `tor01`
  - South America: `sao01`
- **Example**: `"dal12"`
- **Note**: Check available datacenters in your account

### `powervs_zone`
- **Type**: `string`
- **Required**: No
- **Default**: `"us-south"`
- **Description**: PowerVS zone
- **Valid values**: `us-south`, `us-east`, `eu-de`, `eu-gb`, `jp-tok`, `au-syd`, etc.
- **Example**: `"us-south"`

### `powervs_network_name`
- **Type**: `string`
- **Required**: No
- **Default**: `"private-net"`
- **Description**: Name for the PowerVS private network
- **Example**: `"private-net"`

### `powervs_network_cidr`
- **Type**: `string`
- **Required**: No
- **Default**: `"192.168.100.0/24"`
- **Description**: CIDR block for the PowerVS private network
- **Example**: `"192.168.100.0/24"`

### `powervs_network_type`
- **Type**: `string`
- **Required**: No
- **Default**: `"vlan"`
- **Description**: Type of PowerVS network
- **Valid values**: `"vlan"`
- **Example**: `"vlan"`

### `powervs_network_dns`
- **Type**: `list(string)`
- **Required**: No
- **Default**: `["9.9.9.9", "1.1.1.1"]`
- **Description**: DNS servers for PowerVS network
- **Example**: `["9.9.9.9", "1.1.1.1"]`

### `powervs_storage_pool`
- **Type**: `string`
- **Required**: No
- **Default**: `"Tier3"`
- **Description**: Storage pool for PowerVS volumes
- **Valid values**: `"Tier1"` (SSD), `"Tier3"` (HDD)
- **Example**: `"Tier3"`
- **Cost**: Tier1 is more expensive but faster

## AIX Configuration

### `aix_image_name`
- **Type**: `string`
- **Required**: No
- **Default**: `"7300-02-01"`
- **Description**: AIX image name available in the PowerVS datacenter
- **How to find available images**:
  ```bash
  ibmcloud pi workspace target <workspace-id>
  ibmcloud pi images --json
  ```
- **Common values**: `"7200-05-06"`, `"7300-02-01"`, `"7300-02-02"`
- **Example**: `"7300-02-01"`

### AIX Source Instance

#### `aix_source_name`
- **Type**: `string`
- **Required**: No
- **Default**: `"aix-src-01"`
- **Description**: Name for the AIX source instance
- **Example**: `"aix-src-01"`

#### `aix_source_processors`
- **Type**: `string`
- **Required**: No
- **Default**: `"0.5"`
- **Description**: Number of processors for AIX source instance
- **Valid values**: `"0.25"`, `"0.5"`, `"1"`, `"2"`, etc.
- **Example**: `"0.5"`

#### `aix_source_memory`
- **Type**: `string`
- **Required**: No
- **Default**: `"4"`
- **Description**: Memory in GB for AIX source instance
- **Valid values**: Minimum 2GB, must be in increments based on processor count
- **Example**: `"4"`

#### `aix_source_proc_type`
- **Type**: `string`
- **Required**: No
- **Default**: `"shared"`
- **Description**: Processor type for AIX source
- **Valid values**: `"shared"`, `"dedicated"`, `"capped"`
- **Example**: `"shared"`

#### `aix_source_sys_type`
- **Type**: `string`
- **Required**: No
- **Default**: `"s922"`
- **Description**: System type for AIX source
- **Valid values**: `"s922"`, `"e980"`, `"e1080"`, etc.
- **Example**: `"s922"`

### AIX Target Instance

#### `aix_target_name`
- **Type**: `string`
- **Required**: No
- **Default**: `"aix-dst-01"`
- **Description**: Name for the AIX target instance
- **Example**: `"aix-dst-01"`

#### `aix_target_processors`
- **Type**: `string`
- **Required**: No
- **Default**: `"0.5"`
- **Description**: Number of processors for AIX target instance
- **Example**: `"0.5"`

#### `aix_target_memory`
- **Type**: `string`
- **Required**: No
- **Default**: `"4"`
- **Description**: Memory in GB for AIX target instance
- **Example**: `"4"`

#### `aix_target_proc_type`
- **Type**: `string`
- **Required**: No
- **Default**: `"shared"`
- **Description**: Processor type for AIX target
- **Valid values**: `"shared"`, `"dedicated"`, `"capped"`
- **Example**: `"shared"`

#### `aix_target_sys_type`
- **Type**: `string`
- **Required**: No
- **Default**: `"s922"`
- **Description**: System type for AIX target
- **Example**: `"s922"`

### AIX NIM Instance (Optional)

#### `aix_nim_name`
- **Type**: `string`
- **Required**: No
- **Default**: `"aix-nim-01"`
- **Description**: Name for the AIX NIM instance (if created)
- **Example**: `"aix-nim-01"`

#### `aix_nim_processors`
- **Type**: `string`
- **Required**: No
- **Default**: `"0.5"`
- **Description**: Number of processors for AIX NIM instance
- **Example**: `"0.5"`

#### `aix_nim_memory`
- **Type**: `string`
- **Required**: No
- **Default**: `"4"`
- **Description**: Memory in GB for AIX NIM instance
- **Example**: `"4"`

#### `aix_nim_proc_type`
- **Type**: `string`
- **Required**: No
- **Default**: `"shared"`
- **Description**: Processor type for AIX NIM
- **Example**: `"shared"`

#### `aix_nim_sys_type`
- **Type**: `string`
- **Required**: No
- **Default**: `"s922"`
- **Description**: System type for AIX NIM
- **Example**: `"s922"`

## Storage Configuration

### `source_data_volume_size`
- **Type**: `number`
- **Required**: No
- **Default**: `20`
- **Description**: Size in GB for additional data volume on source instance
- **Example**: `20`

### `target_data_volume_size`
- **Type**: `number`
- **Required**: No
- **Default**: `20`
- **Description**: Size in GB for additional data volume on target instance
- **Example**: `20`

### `nim_data_volume_size`
- **Type**: `number`
- **Required**: No
- **Default**: `50`
- **Description**: Size in GB for additional data volume on NIM instance
- **Example**: `50`

## Feature Flags

### `create_nim`
- **Type**: `bool`
- **Required**: No
- **Default**: `false`
- **Description**: Whether to create an AIX NIM server instance
- **Example**: `false`

## Example terraform.tfvars

```hcl
# IBM Cloud Authentication
ibmcloud_api_key = "your-api-key-here"

# General Configuration
region                = "us-south"
zone                  = "us-south-1"
resource_group_name   = "power-migration-lab"
create_resource_group = true
prefix                = "pml"
tags                  = ["power-migration", "sandbox", "terraform"]

# SSH Configuration
ssh_public_key   = "ssh-rsa AAAAB3NzaC1yc2E... user@example.com"
allowed_ssh_cidr = "203.0.113.0/32"  # Your IP

# Cloud Object Storage
create_cos               = true
cos_instance_name        = "migration-artifacts"
cos_bucket_name          = "migration-artifacts"
cos_plan                 = "standard"
cos_bucket_storage_class = "standard"

# VPC Configuration
create_vpc              = true
vpc_name                = "sandbox"
vpc_subnet_cidr         = "10.240.0.0/24"
vpc_address_prefix_cidr = "10.240.0.0/16"

# Bastion Configuration
create_bastion  = true
bastion_name    = "bastion"
bastion_profile = "cx2-2x4"
bastion_image   = "ibm-ubuntu-22-04-3-minimal-amd64-1"

# PowerVS Configuration
powervs_workspace_name        = "migration-lab"
powervs_service_instance_name = "migration-lab"
powervs_datacenter            = "dal12"
powervs_zone                  = "us-south"
powervs_network_name          = "private-net"
powervs_network_cidr          = "192.168.100.0/24"
powervs_network_type          = "vlan"
powervs_network_dns           = ["9.9.9.9", "1.1.1.1"]
powervs_storage_pool          = "Tier3"

# AIX Configuration
aix_image_name = "7300-02-01"

# AIX Source
aix_source_name       = "aix-src-01"
aix_source_processors = "0.5"
aix_source_memory     = "4"
aix_source_proc_type  = "shared"
aix_source_sys_type   = "s922"

# AIX Target
aix_target_name       = "aix-dst-01"
aix_target_processors = "0.5"
aix_target_memory     = "4"
aix_target_proc_type  = "shared"
aix_target_sys_type   = "s922"

# AIX NIM (Optional)
aix_nim_name       = "aix-nim-01"
aix_nim_processors = "0.5"
aix_nim_memory     = "4"
aix_nim_proc_type  = "shared"
aix_nim_sys_type   = "s922"

# Storage Configuration
source_data_volume_size = 20
target_data_volume_size = 20
nim_data_volume_size    = 50

# Feature Flags
create_nim = false
```

## Variable Validation

Some variables have validation rules:

- **prefix**: Must be lowercase alphanumeric with hyphens, start with a letter, max 10 characters
- **CIDR blocks**: Must be valid CIDR notation
- **Processor counts**: Must be valid for PowerVS (0.25, 0.5, 1, 2, etc.)
- **Memory**: Must meet minimum requirements for AIX

## Best Practices

1. **Never commit sensitive values** like API keys to version control
2. **Use meaningful prefixes** to identify resources
3. **Tag resources consistently** for cost tracking and management
4. **Restrict SSH access** to specific IP addresses in production
5. **Choose appropriate instance sizes** based on workload requirements
6. **Use Tier3 storage** for cost savings in non-production environments
7. **Document custom values** in your terraform.tfvars file
8. **Review costs** before applying, especially for production-sized resources

## Getting Help

- Check variable descriptions in `variables.tf`
- Review examples in `terraform.tfvars.example`
- Consult [IBM Cloud documentation](https://cloud.ibm.com/docs)
- Use `terraform plan` to preview changes before applying