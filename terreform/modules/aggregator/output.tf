
output "inventory_path" {
  value = local_file.inventory.filename
}

output "inventory_groups" {
  value = {
    k8s_clusters   = var.k8s_clusters
    standalone_vms = local.standalone_groups
  }
}
