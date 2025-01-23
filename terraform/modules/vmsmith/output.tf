
output "vm_ip" {
  value       = try(proxmox_virtual_environment_vm.vmsmithy.ipv4_addresses[1], ["pending"])
  description = "The IP address of the created VM"
}

output "vm_id" {
  value       = proxmox_virtual_environment_vm.vmsmithy.vm_id
  description = "The ID of the created VM"
}

output "vm_name" {
  value       = proxmox_virtual_environment_vm.vmsmithy.name
  description = "The name of the created VM"
}

output "vm_tags" {
  value       = proxmox_virtual_environment_vm.vmsmithy.tags
  description = "The tags for the VM"
}

output "vm_host" {
  value       = proxmox_virtual_environment_vm.vmsmithy.node_name
  description = "The proxmox host of the VM"
}

