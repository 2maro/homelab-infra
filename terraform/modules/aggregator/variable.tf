variable "inventory_path" {
  type        = string
  description = "Path where the aggregated Ansible inventory file should be written"
}

variable "proxmox_hosts" {
  description = "A map of Proxmox host names to their IP addresses"
  type        = map(string)
}

variable "k8s_clusters" {
  description = "A map of Kubernetes clusters"
  type = map(
    object({
      masters = map(
        object({
          name         = string
          ip           = list(string)
          tags         = list(string)
          proxmox_host = list(string)
        })
      )
      workers = map(
        object({
          name         = string
          ip           = list(string)
          tags         = list(string)
          proxmox_host = list(string)
        })
      )
      ha_nodes = map(
        object({
          name         = string
          ip           = list(string)
          tags         = list(string)
          proxmox_host = list(string)
        })
      )
    })
  )
  default = {}
}

variable "standalone_vms" {
  description = "A map of standalone VMs"
  type = map(
    object({
      name         = string
      ip           = list(string)
      proxmox_host = string
      tags         = list(string)
    })
  )
  default = {}
}

variable "other_clusters" {
  description = "Map of other cluster types (optional)"
  type = map(
    object({
      nodes = map(
        object({
          name         = string
          ip           = list(string)
          tags         = list(string)
          proxmox_host = list(string)
        })
      )
    })
  )
  default = {}
}
