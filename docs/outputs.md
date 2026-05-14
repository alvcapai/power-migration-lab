# Outputs Documentation

This document provides detailed information about all Terraform outputs from this project.

## Table of Contents

- [Viewing Outputs](#viewing-outputs)
- [Resource Group Outputs](#resource-group-outputs)
- [Cloud Object Storage Outputs](#cloud-object-storage-outputs)
- [VPC Outputs](#vpc-outputs)
- [Bastion Outputs](#bastion-outputs)
- [PowerVS Workspace Outputs](#powervs-workspace-outputs)
- [AIX Source Instance Outputs](#aix-source-instance-outputs)
- [AIX Target Instance Outputs](#aix-target-instance-outputs)
- [AIX NIM Instance Outputs](#aix-nim-instance-outputs-optional)
- [Ansible Inventory Output](#ansible-inventory-output)
- [Deployment Summary Output](#deployment-summary-output)
- [Using Outputs](#using-outputs)

## Viewing Outputs

After successfully applying the Terraform configuration, you can view outputs using:

```bash
# View all outputs
terraform output

# View specific output
terraform output bastion_public_ip

# Export all outputs to JSON
terraform output -json > tf_outputs.json

# View specific output in JSON format
terraform output -json bastion_public_ip
```

## Resource Group Outputs

### `resource_group_id`
- **Description**: ID of the resource group
- **Type**: `string`
- **Example**: `"a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6"`
- **Use case**: Reference for other IBM Cloud resources

### `resource_group_name`
- **Description**: Name of the resource group
- **Type**: `string`
- **Example**: `"pml-power-migration-lab"`
- **Use case**: Identifying resources in IBM Cloud console

## Cloud Object Storage Outputs

### `cos_instance_id`
- **Description**: ID of the Cloud Object Storage instance
- **Type**: `string`
- **Example**: `"crn:v1:bluemix:public:cloud-object-storage:global:a/..."`
- **Use case**: Configuring COS access in applications

### `cos_instance_crn`
- **Description**: CRN of the Cloud Object Storage instance
- **Type**: `string`
- **Example**: `"crn:v1:bluemix:public:cloud-object-storage:global:a/..."`
- **Use case**: IAM policies and service bindings

### `cos_bucket_name`
- **Description**: Name of the COS bucket for migration artifacts
- **Type**: `string`
- **Example**: `"pml-migration-artifacts-a1b2c3d4"`
- **Use case**: Uploading/downloading migration artifacts

### `cos_bucket_region`
- **Description**: Region of the COS bucket
- **Type**: `string`
- **Example**: `"us-south"`
- **Use case**: Configuring COS CLI or SDK

## VPC Outputs

### `vpc_id`
- **Description**: ID of the VPC
- **Type**: `string`
- **Example**: `"r006-a1b2c3d4-e5f6-g7h8-i9j0-k1l2m3n4o5p6"`
- **Use case**: Reference for VPC resources

### `vpc_name`
- **Description**: Name of the VPC
- **Type**: `string`
- **Example**: `"pml-sandbox"`
- **Use case**: Identifying VPC in console

### `vpc_subnet_id`
- **Description**: ID of the VPC subnet
- **Type**: `string`
- **Example**: `"0717-a1b2c3d4-e5f6-g7h8-i9j0-k1l2m3n4o5p6"`
- **Use case**: Reference for subnet resources

### `vpc_subnet_cidr`
- **Description**: CIDR block of the VPC subnet
- **Type**: `string`
- **Example**: `"10.240.0.0/24"`
- **Use case**: Network planning and troubleshooting

### `vpc_security_group_id`
- **Description**: ID of the VPC security group
- **Type**: `string`
- **Example**: `"r006-a1b2c3d4-e5f6-g7h8-i9j0-k1l2m3n4o5p6"`
- **Use case**: Reference for security group rules

## Bastion Outputs

### `bastion_id`
- **Description**: ID of the bastion VSI
- **Type**: `string`
- **Example**: `"0717_a1b2c3d4-e5f6-g7h8-i9j0-k1l2m3n4o5p6"`
- **Use case**: Reference for VSI operations

### `bastion_name`
- **Description**: Name of the bastion VSI
- **Type**: `string`
- **Example**: `"pml-bastion"`
- **Use case**: Identifying bastion in console

### `bastion_public_ip`
- **Description**: Public IP address of the bastion VSI
- **Type**: `string`
- **Example**: `"52.116.128.42"`
- **Use case**: SSH access to bastion
- **Usage**:
  ```bash
  ssh -i ~/.ssh/power_migration_lab root@<bastion_public_ip>
  ```

### `bastion_private_ip`
- **Description**: Private IP address of the bastion VSI
- **Type**: `string`
- **Example**: `"10.240.0.4"`
- **Use case**: Internal network reference

## PowerVS Workspace Outputs

### `powervs_workspace_id`
- **Description**: ID of the PowerVS workspace
- **Type**: `string`
- **Example**: `"a1b2c3d4-e5f6-g7h8-i9j0-k1l2m3n4o5p6"`
- **Use case**: Reference for PowerVS operations

### `powervs_workspace_name`
- **Description**: Name of the PowerVS workspace
- **Type**: `string`
- **Example**: `"pml-migration-lab"`
- **Use case**: Identifying workspace in console

### `powervs_workspace_crn`
- **Description**: CRN of the PowerVS workspace
- **Type**: `string`
- **Example**: `"crn:v1:bluemix:public:power-iaas:..."`
- **Use case**: IAM policies and service bindings

### `powervs_network_id`
- **Description**: ID of the PowerVS private network
- **Type**: `string`
- **Example**: `"a1b2c3d4-e5f6-g7h8-i9j0-k1l2m3n4o5p6"`
- **Use case**: Reference for network operations

### `powervs_network_name`
- **Description**: Name of the PowerVS private network
- **Type**: `string`
- **Example**: `"pml-private-net"`
- **Use case**: Identifying network in console

## AIX Source Instance Outputs

### `aix_source_id`
- **Description**: ID of the AIX source instance
- **Type**: `string`
- **Example**: `"a1b2c3d4-e5f6-g7h8-i9j0-k1l2m3n4o5p6"`
- **Use case**: Reference for instance operations

### `aix_source_name`
- **Description**: Name of the AIX source instance
- **Type**: `string`
- **Example**: `"pml-aix-src-01"`
- **Use case**: Identifying instance in console

### `aix_source_private_ip`
- **Description**: Private IP address of the AIX source instance
- **Type**: `string`
- **Example**: `"192.168.100.4"`
- **Use case**: SSH access from bastion
- **Usage**:
  ```bash
  # From bastion
  ssh root@<aix_source_private_ip>
  ```

### `aix_source_data_volume_id`
- **Description**: ID of the AIX source data volume
- **Type**: `string`
- **Example**: `"a1b2c3d4-e5f6-g7h8-i9j0-k1l2m3n4o5p6"`
- **Use case**: Reference for volume operations

### `aix_source_data_volume_name`
- **Description**: Name of the AIX source data volume
- **Type**: `string`
- **Example**: `"pml-aix-src-01-data"`
- **Use case**: Identifying volume in console

## AIX Target Instance Outputs

### `aix_target_id`
- **Description**: ID of the AIX target instance
- **Type**: `string`
- **Example**: `"a1b2c3d4-e5f6-g7h8-i9j0-k1l2m3n4o5p6"`
- **Use case**: Reference for instance operations

### `aix_target_name`
- **Description**: Name of the AIX target instance
- **Type**: `string`
- **Example**: `"pml-aix-dst-01"`
- **Use case**: Identifying instance in console

### `aix_target_private_ip`
- **Description**: Private IP address of the AIX target instance
- **Type**: `string`
- **Example**: `"192.168.100.5"`
- **Use case**: SSH access from bastion
- **Usage**:
  ```bash
  # From bastion
  ssh root@<aix_target_private_ip>
  ```

### `aix_target_data_volume_id`
- **Description**: ID of the AIX target data volume
- **Type**: `string`
- **Example**: `"a1b2c3d4-e5f6-g7h8-i9j0-k1l2m3n4o5p6"`
- **Use case**: Reference for volume operations

### `aix_target_data_volume_name`
- **Description**: Name of the AIX target data volume
- **Type**: `string`
- **Example**: `"pml-aix-dst-01-data"`
- **Use case**: Identifying volume in console

## AIX NIM Instance Outputs (Optional)

These outputs are only available if `create_nim = true`.

### `aix_nim_id`
- **Description**: ID of the AIX NIM instance (if created)
- **Type**: `string` or `null`
- **Example**: `"a1b2c3d4-e5f6-g7h8-i9j0-k1l2m3n4o5p6"` or `null`
- **Use case**: Reference for instance operations

### `aix_nim_name`
- **Description**: Name of the AIX NIM instance (if created)
- **Type**: `string` or `null`
- **Example**: `"pml-aix-nim-01"` or `null`
- **Use case**: Identifying instance in console

### `aix_nim_private_ip`
- **Description**: Private IP address of the AIX NIM instance (if created)
- **Type**: `string` or `null`
- **Example**: `"192.168.100.6"` or `null`
- **Use case**: SSH access from bastion

### `aix_nim_data_volume_id`
- **Description**: ID of the AIX NIM data volume (if created)
- **Type**: `string` or `null`
- **Example**: `"a1b2c3d4-e5f6-g7h8-i9j0-k1l2m3n4o5p6"` or `null`
- **Use case**: Reference for volume operations

### `aix_nim_data_volume_name`
- **Description**: Name of the AIX NIM data volume (if created)
- **Type**: `string` or `null`
- **Example**: `"pml-aix-nim-01-data"` or `null`
- **Use case**: Identifying volume in console

## Ansible Inventory Output

### `ansible_inventory`
- **Description**: Structured data for Ansible inventory generation
- **Type**: `object`
- **Use case**: Generating Ansible inventory files

**Structure**:
```json
{
  "bastion": {
    "host": "52.116.128.42",
    "user": "root",
    "name": "pml-bastion"
  },
  "aix_source": {
    "host": "192.168.100.4",
    "user": "root",
    "name": "pml-aix-src-01"
  },
  "aix_target": {
    "host": "192.168.100.5",
    "user": "root",
    "name": "pml-aix-dst-01"
  },
  "aix_nim": null,
  "cos": {
    "bucket": "pml-migration-artifacts-a1b2c3d4",
    "instance_id": "crn:v1:bluemix:...",
    "instance_crn": "crn:v1:bluemix:...",
    "region": "us-south"
  },
  "powervs": {
    "workspace_id": "a1b2c3d4-...",
    "workspace_name": "pml-migration-lab",
    "network_id": "a1b2c3d4-...",
    "network_name": "pml-private-net"
  },
  "volumes": {
    "source_data": {
      "id": "a1b2c3d4-...",
      "name": "pml-aix-src-01-data"
    },
    "target_data": {
      "id": "a1b2c3d4-...",
      "name": "pml-aix-dst-01-data"
    },
    "nim_data": null
  }
}
```

**Usage Example**:
```bash
# Export to JSON
terraform output -json ansible_inventory > ansible_inventory.json

# Generate Ansible inventory from JSON
cat > inventory.ini <<EOF
[bastion]
$(terraform output -json ansible_inventory | jq -r '.bastion.host') ansible_user=$(terraform output -json ansible_inventory | jq -r '.bastion.user')

[aix_source]
$(terraform output -json ansible_inventory | jq -r '.aix_source.host') ansible_user=$(terraform output -json ansible_inventory | jq -r '.aix_source.user')

[aix_target]
$(terraform output -json ansible_inventory | jq -r '.aix_target.host') ansible_user=$(terraform output -json ansible_inventory | jq -r '.aix_target.user')
EOF
```

## Deployment Summary Output

### `deployment_summary`
- **Description**: Summary of deployed resources
- **Type**: `object`
- **Use case**: Quick overview of deployment

**Structure**:
```json
{
  "resource_group": "pml-power-migration-lab",
  "region": "us-south",
  "zone": "us-south-1",
  "vpc_name": "pml-sandbox",
  "bastion_ip": "52.116.128.42",
  "powervs_workspace": "pml-migration-lab",
  "aix_instances": {
    "source": {
      "name": "pml-aix-src-01",
      "ip": "192.168.100.4"
    },
    "target": {
      "name": "pml-aix-dst-01",
      "ip": "192.168.100.5"
    },
    "nim": null
  },
  "cos_bucket": "pml-migration-artifacts-a1b2c3d4"
}
```

## Using Outputs

### 1. SSH Access

**Connect to Bastion**:
```bash
BASTION_IP=$(terraform output -raw bastion_public_ip)
ssh -i ~/.ssh/power_migration_lab root@$BASTION_IP
```

**Connect to AIX Source from Bastion**:
```bash
AIX_SOURCE_IP=$(terraform output -raw aix_source_private_ip)
ssh root@$AIX_SOURCE_IP
```

**Connect to AIX Target from Bastion**:
```bash
AIX_TARGET_IP=$(terraform output -raw aix_target_private_ip)
ssh root@$AIX_TARGET_IP
```

### 2. Generate Ansible Inventory

**Method 1: Using jq**:
```bash
terraform output -json ansible_inventory | jq -r '
"[bastion]",
(.bastion.host + " ansible_user=" + .bastion.user),
"",
"[aix_source]",
(.aix_source.host + " ansible_user=" + .aix_source.user),
"",
"[aix_target]",
(.aix_target.host + " ansible_user=" + .aix_target.user),
"",
"[aix:children]",
"aix_source",
"aix_target"
' > inventory.ini
```

**Method 2: Using Python**:
```python
import json
import subprocess

# Get outputs
result = subprocess.run(['terraform', 'output', '-json', 'ansible_inventory'], 
                       capture_output=True, text=True)
inventory = json.loads(result.stdout)

# Generate inventory
with open('inventory.ini', 'w') as f:
    f.write(f"[bastion]\n")
    f.write(f"{inventory['bastion']['host']} ansible_user={inventory['bastion']['user']}\n\n")
    
    f.write(f"[aix_source]\n")
    f.write(f"{inventory['aix_source']['host']} ansible_user={inventory['aix_source']['user']}\n\n")
    
    f.write(f"[aix_target]\n")
    f.write(f"{inventory['aix_target']['host']} ansible_user={inventory['aix_target']['user']}\n\n")
    
    f.write(f"[aix:children]\n")
    f.write(f"aix_source\n")
    f.write(f"aix_target\n")
```

### 3. Configure COS Access

```bash
# Get COS details
COS_BUCKET=$(terraform output -raw cos_bucket_name)
COS_REGION=$(terraform output -raw cos_bucket_region)

# Configure IBM Cloud CLI
ibmcloud cos config crn --crn $(terraform output -raw cos_instance_crn)
ibmcloud cos config region --region $COS_REGION

# List bucket contents
ibmcloud cos objects --bucket $COS_BUCKET
```

### 4. Create SSH Config

```bash
BASTION_IP=$(terraform output -raw bastion_public_ip)
AIX_SOURCE_IP=$(terraform output -raw aix_source_private_ip)
AIX_TARGET_IP=$(terraform output -raw aix_target_private_ip)

cat >> ~/.ssh/config <<EOF

# Power Migration Lab
Host pml-bastion
    HostName $BASTION_IP
    User root
    IdentityFile ~/.ssh/power_migration_lab

Host pml-aix-src
    HostName $AIX_SOURCE_IP
    User root
    ProxyJump pml-bastion
    IdentityFile ~/.ssh/power_migration_lab

Host pml-aix-dst
    HostName $AIX_TARGET_IP
    User root
    ProxyJump pml-bastion
    IdentityFile ~/.ssh/power_migration_lab
EOF

# Now you can connect directly
ssh pml-bastion
ssh pml-aix-src
ssh pml-aix-dst
```

### 5. Export All Outputs

```bash
# Export to JSON
terraform output -json > tf_outputs.json

# Export to environment variables
eval $(terraform output -json | jq -r 'to_entries | .[] | "export TF_" + (.key | ascii_upcase) + "=\"" + (.value | tostring) + "\""')

# Now you can use them
echo $TF_BASTION_PUBLIC_IP
echo $TF_AIX_SOURCE_PRIVATE_IP
```

## Output Reference for Scripts

When writing automation scripts, you can reference outputs like this:

**Bash**:
```bash
#!/bin/bash
BASTION_IP=$(terraform output -raw bastion_public_ip)
AIX_SOURCE_IP=$(terraform output -raw aix_source_private_ip)
COS_BUCKET=$(terraform output -raw cos_bucket_name)

# Use in your script
ssh -i ~/.ssh/power_migration_lab root@$BASTION_IP "echo 'Connected to bastion'"
```

**Python**:
```python
import subprocess
import json

def get_terraform_output(output_name):
    result = subprocess.run(
        ['terraform', 'output', '-json', output_name],
        capture_output=True,
        text=True
    )
    return json.loads(result.stdout)

bastion_ip = get_terraform_output('bastion_public_ip')
aix_source_ip = get_terraform_output('aix_source_private_ip')
```

**Ansible**:
```yaml
---
- name: Get Terraform outputs
  hosts: localhost
  tasks:
    - name: Get bastion IP
      command: terraform output -raw bastion_public_ip
      register: bastion_ip
      
    - name: Display bastion IP
      debug:
        msg: "Bastion IP: {{ bastion_ip.stdout }}"
```

## Troubleshooting

### Output Not Available
If an output is not available, it may be because:
- The resource was not created (check `create_*` variables)
- Terraform apply has not been run yet
- The resource creation failed

### Null Values
Some outputs may be `null` if:
- Optional resources were not created (e.g., NIM instance when `create_nim = false`)
- Resource creation is still in progress

### Refreshing Outputs
If outputs seem stale:
```bash
terraform refresh
terraform output
```

## Best Practices

1. **Export outputs after apply**: Always export outputs to a file for reference
2. **Use raw format for scripts**: Use `-raw` flag when using outputs in scripts
3. **Validate outputs**: Check that IPs and IDs are valid before using them
4. **Document custom usage**: If you create custom scripts using outputs, document them
5. **Secure sensitive outputs**: Be careful with outputs containing sensitive data

## Additional Resources

- [Terraform Output Documentation](https://www.terraform.io/docs/language/values/outputs.html)
- [jq Manual](https://stedolan.github.io/jq/manual/)
- [IBM Cloud CLI Documentation](https://cloud.ibm.com/docs/cli)