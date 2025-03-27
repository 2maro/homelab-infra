terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.73.0"
    }
  }
}

resource "proxmox_virtual_environment_vm" "vmsmithy" {
  name        = var.vm_name
  description = "VM Managed by Terraform"
  tags        = [var.tag_name, "terraform"]
  node_name   = var.vm_host
  vm_id       = var.vm_id
  machine     = var.vm_machine_type

  clone {
    vm_id        = var.template_id
    datastore_id = var.primary_disk.storage
    full         = true
  }

  cpu {
    cores = var.vm_cores
    type  = "host"
  }

  memory {
    dedicated = var.vm_memory
    floating  = var.vm_memory
  }

  disk {
    datastore_id = var.primary_disk.storage
    file_format  = "raw"
    interface    = "scsi0"
    size         = var.primary_disk.size
  }


  dynamic "disk" {
    for_each = var.additional_disks
    content {
      datastore_id = disk.value.storage
      file_format  = "raw"
      interface    = "scsi${disk.key + 1}"
      size         = disk.value.size
    }
  }

  network_device {
    model  = "virtio"
    bridge = var.network_bridge
  }

  agent {
    enabled = true
  }

  operating_system {
    type = var.ostype
  }


  on_boot = var.boot_on
  started = true

  initialization {
    datastore_id      = var.primary_disk.storage
    user_data_file_id = "snippets:snippets/shared-cloud-init.yaml"
    interface         = "ide2"
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
  }

  lifecycle {
    ignore_changes = [network_device,
    initialization]
  }
}
