# Homelab Infrastructure 🚀

A collection of Ansible, Packer, and Terraform configurations for provisioning and managing a home lab environment on Proxmox VE. This setup automates the creation of VM templates, spins up VMs, configures Kubernetes clusters, and streamlines system administration tasks.

---

## Table of Contents 📌

1. [Overview](#overview)
2. [Requirements](#requirements)
3. [Usage](#usage)
   - [1. Packer Templates](#1-packer-templates)
   - [2. Terraform Provisioning](#2-terraform-provisioning)
   - [3. Ansible Configuration](#3-ansible-configuration)
4. [License](#license)
5. [Contributing](#contributing)
6. [Contact](#contact)

---

## Overview 🏗️

This repository aims to automate the end-to-end workflow of provisioning and managing a homelab environment. Using **Packer** 🏭, you can build ready-to-use VM templates for Proxmox. Then, leverage **Terraform** 🌍 to stand up VMs and Kubernetes clusters quickly and consistently. Finally, use **Ansible** ⚙️ to configure and maintain services and applications (e.g., NFS servers, monitoring stacks, Vault, etc.) across your infrastructure.

Key goals:

- **Consistency** 📌: Deploy the same base images, configurations, and services every time.
- **Scalability** 📈: Easily add new VMs or clusters without manual setup.
- **Modularity** 🧩: Focus on self-contained modules, roles, and tasks that can be reused and extended.
- **Security** 🔐: Use standardized images, enforce configuration best practices, and manage secrets properly.

---

## Requirements ⚙️

1. **Proxmox VE** 🖥️ environment where VMs will be created and managed.
2. **Terraform** (≥ 1.x) 🏗️ and the [Proxmox Provider (bpg/proxmox)](https://registry.terraform.io/providers/bpg/proxmox/latest).
3. **Packer** CLI 🏭 for building VM templates.
4. **Ansible** (≥ 2.9) ⚙️ for post-deployment configuration and ongoing management.
5. **Valid Proxmox API token** 🔑 with adequate permissions to clone templates and manage VMs.

---

## Usage 🚀

### 1. Packer Templates 🏭

1. **Navigate to the `packer/` directory** (or specific sub-folder):
   ```bash
   cd packer/1000-pkr-rocky9-ks
   ```
2. **Initialize Packer** (if needed):
   ```bash
   packer init .
   ```
3. **Build a template**:
   ```bash
   packer build -var-file=../secret.json builder.pkr.hcl
   ```
   - `secret.json` includes your Proxmox API credentials and other sensitive information (not committed to version control).
4. **Result**: A new VM template is created in Proxmox, ready for cloning.

### 2. Terraform Provisioning 🌍

1. **Go to the `terraform/` directory**:
   ```bash
   cd terraform
   ```
2. **Initialize Terraform**:
   ```bash
   terraform init
   ```
3. **Set/verify your variables** (e.g., `terraform.tfvars` or environment variables):
   ```hcl
   proxmox_apitoken  = "bpg/proxmox"
   proxmox_endpoint  = "https://your-proxmox:8006/api2/json"
   ansible_path      = "/path/to/your/ansible/inventory"
   # etc.
   ```
4. **Plan your changes**:
   ```bash
   terraform plan
   ```
5. **Apply**:
   ```bash
   terraform apply
   ```
   - This will create (or update) your VMs, Kubernetes clusters, etc.
6. **Destroy** (if needed):
   ```bash
   terraform destroy
   ```

### 3. Ansible Configuration ⚙️

1. **Inventory** 📋: The Terraform modules (like `aggregator`) can write inventory data for Ansible. Alternatively, maintain a dedicated inventory file in `ansible/inventories`.
2. **Roles**:
   - Each directory under `ansible/roles/` houses tasks, defaults, handlers, templates, etc., for a given service:
     - `clamav` 🛡️: Anti-virus scanning.
     - `common` 🏗️: Common tasks for all servers (user setup, package updates).
     - `grafana` 📊: Install and configure Grafana for monitoring dashboards.
     - `prometheus`, `node_exporter`, `promtail_agent`, `loki` 🔍: Monitoring and log-aggregation stack roles.
     - `vault`, `wazuh`, `stepca` 🔐: Security, intrusion detection, and PKI services.
     - And more...
3. **Playbooks**:
   - Create or use an existing playbook (e.g., `ansible/playbooks/site.yml`) to orchestrate role execution across hosts.

Example usage:

```bash
cd ansible
ansible-playbook -i inventories/hosts playbooks/site.yml
```

---

## License 📜

This project is licensed under the terms of the [MIT License](LICENSE).\
Feel free to use, modify, and distribute this work as permitted under the license.

---

## Contributing 🤝

Contributions are welcome! Please open an issue or submit a pull request for any improvements, bug fixes, or enhancements.

1. Fork the repository 🍴
2. Create a new branch (`git checkout -b feature/my-feature`) 🌿
3. Commit changes (`git commit -m "Add some feature"`) 📝
4. Push to the branch (`git push origin feature/my-feature`) 🚀
5. Create a Pull Request 📩

---

## Contact 📧

For any questions, suggestions, or feedback, feel free to reach out via GitHub issues or contact the repository owner directly.

---

> **Note** ⚠️: Always ensure you safeguard credentials (e.g., `.json` files with tokens or passwords) by excluding them from version control (e.g., add them to your `.gitignore`). You can also use HashiCorp Vault, Ansible Vault, or other secrets managers for more robust protection.
