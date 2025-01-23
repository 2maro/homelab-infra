# Terraform Proxmox Infrastructure 🚀

Automate the creation and management of virtual machines and Kubernetes clusters on Proxmox VE using Terraform.

## 1. OVERVIEW 📚

**Goal:** Streamline VM and Kubernetes deployment in a Proxmox environment.

**Features:**
- 🏷️ Template-based VM provisioning
- 🗷️ Configurable K8s clusters (masters, workers, HA nodes)
- 📦 Automatic inventory aggregation for Ansible or other tools 
- ♻️ Modular structure for easy reuse and customization

## 2. REQUIREMENTS ⚙️

- **Terraform ≥ 1.x** 
- **Proxmox Provider** (bpg/proxmox), e.g. `~> 0.68.0` 
- A **Proxmox VE** environment ready for VM cloning 
- Network configuration matching your `network_bridge` variable

## 3. QUICK START 🚀

1. **Clone** the repo:
   ```bash
   git clone https://github.com/your-org/your-repo.git
   cd your-repo
   ```

2. **Configure variables** in `terraform.tfvars`:
   ```hcl
   # Required Provider Configuration
   proxmox_apitoken  = "bpg/proxmox"
   proxmox_endpoint  = "https://your-proxmox:8006/api2/json"
   ansible_path      = "/path/to/your/ansible/inventory"
   ```

3. **Initialize Terraform:**
   ```bash
   terraform init
   ```

4. **Plan and Apply:**
   ```bash
   terraform plan
   terraform apply
   ```
   *(Confirm to provision resources.)*

5. **Destroy resources if needed:**
   ```bash
   terraform destroy
   ```

## 4. MODULES (HIGHLIGHTED BELOW) 🔍


### K8s Cluster 

- **Location:** `modules/k8s` 
- **Purpose:** Creates a configurable Kubernetes cluster (masters, workers, HA nodes).

#### Key Inputs:
- `cluster_name`, `master_count`, `worker_count`, `ha_count`
- `vm_cores`, `vm_memory`, `primary_disk`, `template_id`, `vm_host`

#### Example usage in `main.tf`:
```terraform
module "k8s_cluster" {
  source       = "./modules/k8s"
  cluster_name = "prod-cluster"
  master_count = 3
  worker_count = 3
  ...
}
```

### VMSmith 🖥️ 

- **Location:** `modules/vmsmith` 
- **Purpose:** Clones and configures standalone VMs from a template.

#### Key Inputs:
- `vm_name`, `vm_id`, `tag_name`, `vm_cores`, `vm_memory`, `primary_disk`, `additional_disks`

#### Example usage in `main.tf`:
```terraform
module "standalone_vms" {
  source   = "./modules/vmsmith"
  for_each = { for vm in local.vm_instances : vm.name => vm }
  vm_name  = each.value.vm_name
  ...
}
```

###  Aggregator 🔎 

- **Location:** `modules/aggregator` 
- **Purpose:** Gathers and writes inventory data (e.g., for Ansible).

#### Key Inputs:
- `inventory_path`
- `k8s_clusters`
- `standalone_vms`
