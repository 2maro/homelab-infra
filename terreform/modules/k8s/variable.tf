variable "cluster_name" {
  type        = string
  description = "Name of the Kubernetes cluster"
}

variable "master_count" {
  type        = number
  description = "Number of master nodes"
  default     = 1
}

variable "worker_count" {
  type        = number
  description = "Number of worker nodes"
  default     = 2
}

variable "ha_count" {
  type        = number
  description = "Number of HA nodes"
  default     = 0
}

variable "starting_vm_id" {
  type        = number
  description = "Starting VM ID for the cluster nodes"
  default     = 1100
}

variable "vm_cores" {
  type        = number
  description = "Number of CPU cores"
  default     = 2
}

variable "vm_memory" {
  type        = number
  description = "Memory in MB"
  default     = 4096
}

variable "vm_machine_type" {
  type        = string
  description = "Machine type"
  default     = "q35"
}

variable "primary_disk" {
  description = "Configuration for the primary disk"
  type = object({
    size    = number
    storage = string
  })
}

variable "vm_host" {
  type        = string
  description = "Proxmox host to deploy the VMs on"
}


variable "template_id" {
  type        = number
  description = "Template ID to clone from"
}

variable "network_bridge" {
  type        = string
  description = "Network bridge to connect to"
  default     = "vmbr0"
}

variable "boot_on" {
  type        = bool
  description = "Start VMs on boot"
  default     = true
}
