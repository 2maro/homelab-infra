variable "vm_name" {
  type        = string
  description = "Name of the virtual machine"
}

variable "vm_host" {
  type        = string
  description = "Proxmox host to deploy the VM on"
}

variable "vm_id" {
  type        = number
  description = "ID for the virtual machine"
}

variable "template_id" {
  type        = number
  description = "Template ID to clone from"
}

variable "primary_disk" {
  description = "Configuration for the primary disk"
  type = object({
    size    = number
    storage = string
  })
}
variable "additional_disks" {
  description = "configuration for additional disks"
  type = list(object({
    size    = number
    storage = string
  }))
  default = []
}
variable "vm_cores" {
  type        = number
  description = "Number of CPU cores"
  default     = 2
}

variable "vm_memory" {
  type        = number
  description = "Memory in MB"
  default     = 2048
}


variable "network_bridge" {
  type        = string
  description = "Network bridge to connect to"
  default     = "vmbr0"
}

variable "vm_machine_type" {
  type        = string
  description = "Machine type"
  default     = "q35"
}

variable "ostype" {
  type        = string
  description = "Operating system type"
  default     = "l26"
}

variable "boot_on" {
  type        = bool
  description = "Start VM on boot"
  default     = true
}

variable "tag_name" {
  type        = string
  description = "Primary tag for the VM"
}
