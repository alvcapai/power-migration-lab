#!/usr/bin/env python3
"""
Generate Ansible inventory from Terraform outputs.

Usage:
    terraform output -json > tf_outputs.json
    python3 inventory/generate_inventory.py tf_outputs.json > inventory/inventory.ini
"""

import json
import sys
from pathlib import Path


def generate_inventory(tf_outputs):
    """Generate Ansible inventory from Terraform outputs."""
    
    # Extract ansible_inventory from outputs
    if 'ansible_inventory' in tf_outputs:
        inventory_data = tf_outputs['ansible_inventory']['value']
    else:
        print("Error: 'ansible_inventory' not found in Terraform outputs", file=sys.stderr)
        sys.exit(1)
    
    inventory = []
    
    # Bastion host
    if inventory_data.get('bastion'):
        bastion = inventory_data['bastion']
        inventory.append("[bastion]")
        inventory.append(f"linux-staging ansible_host={bastion['host']} ansible_user={bastion['user']}")
        inventory.append("")
    
    # AIX Source
    if inventory_data.get('aix_source'):
        aix_source = inventory_data['aix_source']
        inventory.append("[aix_source]")
        inventory.append(f"aix-src-01 ansible_host={aix_source['host']} ansible_user={aix_source['user']}")
        inventory.append("")
    
    # AIX Target
    if inventory_data.get('aix_target'):
        aix_target = inventory_data['aix_target']
        inventory.append("[aix_target]")
        inventory.append(f"aix-dst-01 ansible_host={aix_target['host']} ansible_user={aix_target['user']}")
        inventory.append("")
    
    # AIX NIM (optional)
    if inventory_data.get('aix_nim') and inventory_data['aix_nim'] is not None:
        aix_nim = inventory_data['aix_nim']
        inventory.append("[aix_nim]")
        inventory.append(f"aix-nim-01 ansible_host={aix_nim['host']} ansible_user={aix_nim['user']}")
        inventory.append("")
    
    # AIX group
    inventory.append("[aix:children]")
    inventory.append("aix_source")
    inventory.append("aix_target")
    if inventory_data.get('aix_nim') and inventory_data['aix_nim'] is not None:
        inventory.append("aix_nim")
    inventory.append("")
    
    # Add variables as comments for reference
    inventory.append("# COS Bucket: " + inventory_data.get('cos', {}).get('bucket', 'N/A'))
    inventory.append("# PowerVS Workspace: " + inventory_data.get('powervs', {}).get('workspace_name', 'N/A'))
    
    return "\n".join(inventory)


def main():
    """Main function."""
    if len(sys.argv) != 2:
        print("Usage: python3 generate_inventory.py <tf_outputs.json>", file=sys.stderr)
        print("\nExample:", file=sys.stderr)
        print("  terraform output -json > tf_outputs.json", file=sys.stderr)
        print("  python3 inventory/generate_inventory.py tf_outputs.json > inventory/inventory.ini", file=sys.stderr)
        sys.exit(1)
    
    tf_outputs_file = Path(sys.argv[1])
    
    if not tf_outputs_file.exists():
        print(f"Error: File '{tf_outputs_file}' not found", file=sys.stderr)
        sys.exit(1)
    
    try:
        with open(tf_outputs_file, 'r') as f:
            tf_outputs = json.load(f)
    except json.JSONDecodeError as e:
        print(f"Error: Invalid JSON in '{tf_outputs_file}': {e}", file=sys.stderr)
        sys.exit(1)
    
    inventory = generate_inventory(tf_outputs)
    print(inventory)


if __name__ == '__main__':
    main()

# Made with Bob
