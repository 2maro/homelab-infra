# Packer Proxmox Project

## Overview
✨ This Packer project automates the creation of Proxmox VM templates for various operating systems, focusing on streamlined configurations and optimized templates for deployment in virtualized environments.

## Features
- 🖥️ **Multi-OS Support:** Build VM templates for various Linux distributions.
- ☁️ **Cloud-Init and Kickstart:** Includes automated configurations for provisioning.
- 🔧 **Customizable:** Supports user-defined hardware, network, and boot configurations.
- 🚀 **Provisioning Scripts:** Tailored post-build scripts for optimized VM setup.

## Prerequisites
- 🖥️ Proxmox Virtual Environment.
- 🛠️ Packer CLI.
- 🔑 A valid Proxmox API token with sufficient permissions.

## Configuration Files
### Per-Image Folders
📁 Each image folder contains:
- **Packer Templates (`builder.pkr.hcl`)**: Defines the build process for that image.
- **HTTP Directory (`http/`)**: Contains kickstart or Cloud-init file for automated installation.

### Secrets File (`secret.json`)
🔒 Contains sensitive variables like API tokens (excluded from version control).

## Variables
- 🌐 `proxmox_url`: Proxmox API endpoint.
- 👤 `username`: Proxmox user with API access.
- 🔑 `token`: Proxmox API token.
- 🚨 `insecure_skip_tls_verify`: Skip TLS verification for the API.
- 🔑 `ssh_password`: Default SSH password for the VMs.
- 🖥️ `node`: Proxmox node for deployment.
- 💾 `disk_size`: Disk size for the VMs.
- 📂 `localiso`: Path to the ISO file in Proxmox storage.

## Usage
### 1. Initialize Packer
⚙️ Run the following command to initialize Packer:
```bash
packer init .
```

### 2. Build a Template
🛠️ To build a specific image (e.g., for Rocky Linux):
```bash
cd 1000-pkr-rocky9-ks
packer build -var-file=../secret.json builder.pkr.hcl
```

### 3. Access Your Templates
🚀 Once built, the templates are available in Proxmox under the storage configured in your variables.

### 4. Clean Up
🧹 After building, templates are ready for deployment and provisioning in your Proxmox environment.
