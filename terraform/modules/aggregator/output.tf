output "inventory_path" {
  description = "The path where the aggregated Ansible inventory file was created"
  value       = local_file.inventory.filename
}

output "inventory_groups" {
  description = <<-EOT
    Aggregated inventory data for k8s clusters, standalone VMs,
    and other clusters (if provided).
  EOT

  value = {
    k8s_clusters   = var.k8s_clusters
    standalone_vms = local.standalone_groups
    other_clusters = var.other_clusters
  }
}
