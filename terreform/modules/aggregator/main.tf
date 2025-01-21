terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4.0"
    }
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.63"
    }
  }
}

locals {
  has_k8s        = length(var.k8s_clusters) > 0
  has_standalone = length(var.standalone_vms) > 0
  vm_host        = try(values(var.standalone_vms)[0].proxmox_host, "prime")
  vm_host_ip     = try(values(var.standalone_vms)[0].ip[0], "192.168.1.3")

  # Add the missing standalone_groups local
  standalone_groups = {
    for vm_name, vm in var.standalone_vms : vm_name => {
      name         = vm.name
      ip           = vm.ip
      tags         = vm.tags
      proxmox_host = vm.proxmox_host
    }
  }

  template_vars = {
    k8s_clusters   = var.k8s_clusters
    standalone_vms = var.standalone_vms
    has_k8s        = local.has_k8s
    has_standalone = local.has_standalone
    vm_host        = local.vm_host
    vm_host_ip     = local.vm_host_ip
  }

  inventory_content = <<-EOT
${templatefile("${path.module}/templates/vmsmith_inventory.tpl", local.template_vars)}
${templatefile("${path.module}/templates/k8s_inventory.tpl", local.template_vars)}
EOT
}

resource "local_file" "inventory" {
  filename        = var.inventory_path
  content         = local.inventory_content
  file_permission = "0644"
}
