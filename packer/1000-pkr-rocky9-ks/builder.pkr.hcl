packer {
  required_plugins {
    proxmox = {
      version = "v1.2.1"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

variable "proxmox_url" {
  type    = string
  default = "http://xxx.xx.x.x:8006/api2/json"
}
variable "username" {
  type    = string
  default = "name@pam!xxxxxxxx"
}
variable "token" {
  type    = string
  default = "xx-xxxx-xxxx-xxxxxxxxxxxx"
}

variable "insecure_skip_tls_verify" {
  type    = bool
  default = true
}
variable "ssh_password" {
  type    = string
  default = "password"
}
variable "node" {
  type    = string
  default = "nameofyournode"
}
variable "disk_size" {
  type    = string
  default = "20G"
}
variable "localiso" {
  type    = string
  default = "local:iso/nameofyouriso"
}

source "proxmox-iso" "rocky9" {

  proxmox_url              = var.proxmox_url
  username                 = var.username
  token                    = var.token
  insecure_skip_tls_verify = var.insecure_skip_tls_verify
  node                     = var.node
  vm_id                    = 1000
  vm_name                  = "rocky9-base"
  template_name            = "rocky-server-template"
  template_description     = "rocky-9.5, generated on ${timestamp()}"
  ssh_username             = "root"
  ssh_password             = "password"
  numa                     = true
  cores                    = 2
  memory                   = 2048
  os                       = "l26"
  qemu_agent               = true
  machine                  = "q35"
  cpu_type                 = "host"
  http_directory           = "http"
  http_port_min            = 8613
  http_port_max            = 8613
  http_bind_address        = "0.0.0.0"
  communicator             = "none"
  task_timeout             = "10m"
  scsi_controller          = "virtio-scsi-pci"
  boot_iso {
    type     = "scsi"
    iso_file = var.localiso
    unmount  = true
  }

  disks {
    type         = "virtio"
    disk_size    = var.disk_size
    storage_pool = "local-lvm"
    format       = "raw"
  }
  network_adapters {
    model    = "virtio"
    bridge   = "vmbr0"
    firewall = false
  }

  boot_command = [
    "<tab>",
    " inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/rocky9-ks.cfg",
    " inst.stage2=cdrom",
    " inst.text",
    " ip=dhcp",
    " <enter>",
    " <enter>"
  ]

}

build {
  name    = "rocky-server-template"
  sources = ["source.proxmox-iso.rocky9"]
}
