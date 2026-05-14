# AIX Migration Lab - Ansible Automation

## Overview

This Ansible project automates the OS-level tasks for an AIX migration sandbox to IBM Power Virtual Server. It works in conjunction with the Terraform infrastructure provisioning project.

**Important**: This project handles **only OS-level automation**. Infrastructure provisioning is done separately via Terraform.

## Architecture

```
Terraform (Infrastructure)
    ↓
    Creates: VPC, PowerVS, AIX instances, COS
    Outputs: tf_outputs.json
    ↓
Ansible (OS Automation)
    ↓
    Consumes: tf_outputs.json
    Executes: Backup, transfer, restore, validate
```

## Relationship with Terraform

1. **Terraform** creates the infrastructure:
   - Resource Group
   - VPC with bastion
   - PowerVS workspace
   - AIX source and target instances
   - Cloud Object Storage

2. **Ansible** configures and migrates:
   - Prepares AIX source system
   - Creates backups (mksysb, savevg)
   - Transfers artifacts
   - Restores on target
   - Validates migration

## Prerequisites

### Required Software
- Ansible >= 2.14
- Python >= 3.8
- SSH client
- jq (for JSON processing)

### IBM Cloud Resources
- Terraform infrastructure already provisioned
- `tf_outputs.json` file from Terraform
- SSH access to all instances
- Root or equivalent privileges on AIX systems

### AIX Requirements
- AIX 7.2 or 7.3
- Sufficient disk space for backups
- Network connectivity between instances

### Python on AIX
Some Ansible modules require Python on AIX. If not available:
- Use `raw` module for commands
- Or install Python: `yum install python3` (if yum is configured)
- This project primarily uses `raw` module to avoid Python dependency

## Quick Start

### 1. Install Ansible Dependencies

```bash
cd ansible
ansible-galaxy collection install -r requirements.yml
```

### 2. Generate Inventory

```bash
# From Terraform directory, export outputs
cd ../terraform
terraform output -json > tf_outputs.json

# Generate Ansible inventory
cd ../ansible
python3 inventory/generate_inventory.py ../terraform/tf_outputs.json > inventory/inventory.ini
```

### 3. Test Connectivity

```bash
ansible-playbook -i inventory/inventory.ini playbooks/00_ping.yml
```

### 4. Run Migration Workflow

#### Option A: Step by Step

```bash
# Step 1: Prepare source
ansible-playbook -i inventory/inventory.ini playbooks/01_prepare_source.yml

# Step 2: Backup source
ansible-playbook -i inventory/inventory.ini playbooks/02_backup_source.yml

# Step 3: Transfer artifacts
ansible-playbook -i inventory/inventory.ini playbooks/03_transfer_artifacts.yml

# Step 4: Restore target (DESTRUCTIVE!)
ansible-playbook -i inventory/inventory.ini playbooks/04_restore_target_datavg.yml \
  -e "target_restore_disk=hdisk1 confirm_destructive_actions=true"

# Step 5: Validate
ansible-playbook -i inventory/inventory.ini playbooks/05_validate_migration.yml
```

#### Option B: Complete Workflow

```bash
ansible-playbook -i inventory/inventory.ini playbooks/site.yml \
  -e "target_restore_disk=hdisk1 confirm_destructive_actions=true"
```

## Project Structure

```
ansible/
├── README.md                          # This file
├── ansible.cfg                        # Ansible configuration
├── requirements.yml                   # Galaxy dependencies
├── inventory/
│   ├── inventory.ini.example          # Example inventory
│   └── generate_inventory.py          # Script to generate from Terraform
├── group_vars/
│   └── all.yml                        # Global variables
├── host_vars/
│   ├── aix-src-01.yml                 # Source host variables
│   ├── aix-dst-01.yml                 # Target host variables
│   └── linux-staging.yml              # Staging host variables
├── playbooks/
│   ├── 00_ping.yml                    # Connectivity test
│   ├── 01_prepare_source.yml          # Prepare source system
│   ├── 02_backup_source.yml           # Create backups
│   ├── 03_transfer_artifacts.yml      # Transfer files
│   ├── 04_restore_target_datavg.yml   # Restore on target
│   ├── 05_validate_migration.yml      # Validate migration
│   └── site.yml                       # Master playbook
├── roles/
│   ├── aix_common/                    # Common AIX tasks
│   ├── aix_prepare_source/            # Source preparation
│   ├── aix_backup/                    # Backup operations
│   ├── artifact_transfer/             # File transfers
│   ├── aix_restore_datavg/            # Restore operations
│   └── aix_validate/                  # Validation tasks
├── scripts/
│   ├── aix_prepare_source.ksh         # Source preparation script
│   ├── aix_backup_source.ksh          # Backup script
│   ├── aix_restore_datavg.ksh         # Restore script
│   └── aix_validate_migration.ksh     # Validation script
└── reports/
    └── .gitkeep                       # Reports directory
```

## Playbooks

### 00_ping.yml - Connectivity Test
Tests SSH connectivity to all hosts using AIX-compatible commands.

**Usage**:
```bash
ansible-playbook -i inventory/inventory.ini playbooks/00_ping.yml
```

### 01_prepare_source.yml - Prepare Source
Prepares the AIX source system:
- Creates backup directory
- Identifies available disks
- Creates datavg volume group
- Creates filesystem at /appdata
- Generates fake application data

**Usage**:
```bash
ansible-playbook -i inventory/inventory.ini playbooks/01_prepare_source.yml
```

**Variables**:
- `source_data_disk`: Disk to use for datavg (optional, auto-detect if not set)

### 02_backup_source.yml - Create Backups
Creates mksysb and savevg backups:
- Runs `mksysb -i /backup/source_rootvg.mksysb`
- Runs `savevg -f /backup/source_datavg.savevg datavg`
- Validates backup files
- Tests backup readability

**Usage**:
```bash
ansible-playbook -i inventory/inventory.ini playbooks/02_backup_source.yml
```

**Duration**: 30-60 minutes depending on data size

### 03_transfer_artifacts.yml - Transfer Files
Transfers backup artifacts:
1. AIX Source → Linux Staging
2. Linux Staging → AIX Target
3. Optionally: Linux Staging → IBM COS

**Usage**:
```bash
ansible-playbook -i inventory/inventory.ini playbooks/03_transfer_artifacts.yml
```

**Variables**:
- `enable_cos_upload`: Set to true to upload to COS (default: false)

### 04_restore_target_datavg.yml - Restore Target
Restores datavg on target system.

**⚠️ WARNING**: This is a DESTRUCTIVE operation!

**Usage**:
```bash
ansible-playbook -i inventory/inventory.ini playbooks/04_restore_target_datavg.yml \
  -e "target_restore_disk=hdisk1 confirm_destructive_actions=true"
```

**Required Variables**:
- `target_restore_disk`: Disk to use (e.g., hdisk1)
- `confirm_destructive_actions`: Must be true

**Safety Features**:
- Requires explicit disk specification
- Requires explicit confirmation
- 5-second pause before execution
- Validates disk availability

### 05_validate_migration.yml - Validate
Validates the migration:
- Compares OS levels
- Verifies volume groups
- Checks filesystems
- Validates data integrity
- Generates report

**Usage**:
```bash
ansible-playbook -i inventory/inventory.ini playbooks/05_validate_migration.yml
```

**Output**: `reports/migration-report-<timestamp>.md`

### site.yml - Complete Workflow
Runs all playbooks in sequence.

**Usage**:
```bash
ansible-playbook -i inventory/inventory.ini playbooks/site.yml \
  -e "target_restore_disk=hdisk1 confirm_destructive_actions=true"
```

## Variables

### Global Variables (group_vars/all.yml)

| Variable | Default | Description |
|----------|---------|-------------|
| `migration_id` | `aix-powervs-lab` | Migration identifier |
| `backup_dir_aix` | `/backup` | Backup directory on AIX |
| `staging_dir_linux` | `/data/migration` | Staging directory on Linux |
| `appdata_mount` | `/appdata` | Application data mount point |
| `source_data_vg` | `datavg` | Source volume group name |
| `source_data_lv` | `applv` | Source logical volume name |
| `source_data_fs_size` | `5G` | Filesystem size |
| `rootvg_mksysb_name` | `source_rootvg.mksysb` | mksysb filename |
| `datavg_savevg_name` | `source_datavg.savevg` | savevg filename |
| `enable_cos_upload` | `false` | Upload to COS |
| `confirm_destructive_actions` | `false` | Confirm destructive ops |
| `target_restore_disk` | `""` | Target disk for restore |

### Host-Specific Variables

See `host_vars/` directory for host-specific configurations.

## Roles

### aix_common
Common tasks for all AIX hosts:
- Get system information
- Create backup directory
- Set facts

### aix_prepare_source
Prepares source system:
- Identifies available disks
- Creates volume group
- Creates filesystem
- Generates fake data

### aix_backup
Creates backups:
- Runs mksysb
- Runs savevg
- Validates backups

### artifact_transfer
Transfers files:
- Fetches from source
- Copies to staging
- Copies to target
- Optionally uploads to COS

### aix_restore_datavg
Restores on target:
- Validates prerequisites
- Runs restvg
- Verifies restoration

### aix_validate
Validates migration:
- Collects evidence
- Compares systems
- Generates report

## Scripts

KSH scripts in `scripts/` directory provide AIX-specific logic:

- `aix_prepare_source.ksh`: Source preparation
- `aix_backup_source.ksh`: Backup operations
- `aix_restore_datavg.ksh`: Restore operations
- `aix_validate_migration.ksh`: Validation checks

These scripts are deployed and executed by Ansible roles.

## Important Limitations

### What This Project Does
✅ Creates backup directory structure
✅ Creates datavg and filesystems
✅ Generates mksysb and savevg
✅ Transfers artifacts
✅ Restores datavg on target
✅ Validates data integrity

### What This Project Does NOT Do
❌ Restore rootvg automatically
❌ Boot target from restored rootvg
❌ Configure NIM server
❌ Handle real applications
❌ Manage databases
❌ Configure PowerHA/clustering
❌ Handle SAN/VIOS/NPIV
❌ Perform production cutover
❌ Update DNS/load balancers

### rootvg Restore

**Important**: This project does NOT automatically restore rootvg.

For rootvg restore, you have these options:

1. **Manual Restore** (Recommended for learning):
   - Boot target from NIM or installation media
   - Manually run: `restore -xvf /backup/source_rootvg.mksysb`
   - Follow AIX prompts

2. **NIM-Based Restore** (Future enhancement):
   - Configure NIM server
   - Use `nim -o bos_inst` for network boot
   - Automated but requires NIM setup

3. **Production Approach**:
   - Use IBM's migration tools
   - Engage IBM Services
   - Follow formal change management

## Security Considerations

### SSH Keys
- Never commit private keys to version control
- Use separate keys for lab vs production
- Rotate keys regularly

### Credentials
- Use Ansible Vault for sensitive data
- Don't hardcode passwords
- Use IAM for COS access

### Destructive Operations
- Always verify disk names before restore
- Use confirmation flags
- Test in sandbox first
- Have rollback plan

## Troubleshooting

### Connectivity Issues
```bash
# Test SSH manually
ssh root@<aix-ip>

# Check SSH config
cat ~/.ssh/config

# Verify inventory
ansible-inventory -i inventory/inventory.ini --list
```

### Python Not Found on AIX
This project uses `raw` module to avoid Python dependency. If you see Python errors:
- Check that playbooks use `gather_facts: false`
- Verify tasks use `ansible.builtin.raw` module
- Or install Python on AIX: `yum install python3`

### Disk Not Found
```bash
# On AIX, list available disks
lspv

# Check disk status
lspv hdisk1

# Verify disk is not in use
lsvg -p datavg
```

### Backup Fails
```bash
# Check disk space
df -g /backup

# Check for errors
errpt | head

# Verify volume group
lsvg datavg
```

### Transfer Fails
```bash
# Check network connectivity
ping <target-ip>

# Check disk space on staging
df -h /data/migration

# Verify SSH keys
ssh-add -l
```

## Best Practices

### Before Running
1. Review all variables in `group_vars/all.yml`
2. Verify inventory is correct
3. Test connectivity with `00_ping.yml`
4. Ensure sufficient disk space
5. Have rollback plan

### During Execution
1. Monitor logs: `tail -f ansible.log`
2. Watch for errors
3. Don't interrupt long-running tasks
4. Keep terminal session active

### After Completion
1. Review validation report
2. Test applications on target
3. Document any issues
4. Save logs for reference

## Integration with Terraform

### Workflow
```bash
# 1. Provision infrastructure with Terraform
cd terraform
terraform apply -var-file="terraform.tfvars"
terraform output -json > tf_outputs.json

# 2. Generate Ansible inventory
cd ../ansible
python3 inventory/generate_inventory.py ../terraform/tf_outputs.json > inventory/inventory.ini

# 3. Run Ansible automation
ansible-playbook -i inventory/inventory.ini playbooks/site.yml \
  -e "target_restore_disk=hdisk1 confirm_destructive_actions=true"

# 4. Review results
cat reports/migration-report-*.md
```

### Cleanup
```bash
# Ansible doesn't destroy infrastructure
# Use Terraform to destroy
cd terraform
terraform destroy -var-file="terraform.tfvars"
```

## Future Enhancements

### Planned Features
- [ ] NIM server configuration role
- [ ] Automated rootvg restore via NIM
- [ ] COS integration with IBM Cloud CLI
- [ ] Performance metrics collection
- [ ] Application-specific validation
- [ ] Multi-wave migration support
- [ ] HTML report generation
- [ ] Email notifications
- [ ] Rollback automation

### Contributions
Contributions are welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Test thoroughly
4. Submit pull request

## References

### IBM Documentation
- [AIX Documentation](https://www.ibm.com/docs/en/aix/)
- [mksysb Command](https://www.ibm.com/docs/en/aix/7.3?topic=m-mksysb-command)
- [savevg Command](https://www.ibm.com/docs/en/aix/7.3?topic=s-savevg-command)
- [restvg Command](https://www.ibm.com/docs/en/aix/7.3?topic=r-restvg-command)
- [NIM Documentation](https://www.ibm.com/docs/en/aix/7.3?topic=management-network-installation)

### Ansible Documentation
- [Ansible Documentation](https://docs.ansible.com/)
- [Raw Module](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/raw_module.html)
- [Best Practices](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html)

### IBM Cloud
- [Power Virtual Server](https://cloud.ibm.com/docs/power-iaas)
- [Cloud Object Storage](https://cloud.ibm.com/docs/cloud-object-storage)

## Support

For issues or questions:
1. Check this README
2. Review Terraform documentation
3. Check Ansible logs
4. Consult IBM documentation
5. Open an issue in the repository

## License

This project is provided as an educational example for AIX migration to PowerVS.

---

**Remember**: This is a SANDBOX environment for learning. Production migrations require additional planning, testing, and professional services.