
variable "inventory_path" {
  type        = string
  description = "Path to the Ansible inventory file"
}

variable "k8s_clusters" {
  type = map(object({
    masters = map(object({
      name         = string
      ip           = list(string)
      tags         = list(string)
      proxmox_host = list(string)
    }))
    workers = map(object({
      name         = string
      ip           = list(string)
      tags         = list(string)
      proxmox_host = list(string)
    }))
    ha_nodes = map(object({
      name         = string
      ip           = list(string)
      tags         = list(string)
      proxmox_host = list(string)

    }))
  }))
  default = {}
}

variable "standalone_vms" {
  type = map(object({
    name         = string
    ip           = list(string)
    proxmox_host = string
    tags         = list(string)
  }))
  default = {}
}
