
output "master_nodes" {
  value = {
    for key, mod in module.masters : key => {
      name         = mod.vm_name
      ip           = mod.vm_ip
      tags         = mod.vm_tags
      proxmox_host = [mod.vm_host]
    }
  }
}

output "worker_nodes" {
  value = {
    for key, mod in module.workers : key => {
      name         = mod.vm_name
      ip           = mod.vm_ip
      tags         = mod.vm_tags
      proxmox_host = [mod.vm_host]
    }
  }
}

output "ha_nodes" {
  value = {
    for key, mod in module.ha_nodes : key => {
      name         = mod.vm_name
      ip           = mod.vm_ip
      tags         = mod.vm_tags
      proxmox_host = [mod.vm_host]
    }
  }
}
