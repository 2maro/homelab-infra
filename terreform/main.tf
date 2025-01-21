locals {
  common_vars = {
    vm_host   = "prime"
    vm_cores  = 2
    vm_memory = 4096
    primary_disk = {
      size    = 30
      storage = "local-lvm"
    }
  }

  vms = {

    samba = {
      count            = 1
      base_id          = 1071
      template_id      = 1000
      tag_name         = "storage"
      storage          = local.common_vars.primary_disk.storage
      additional_disks = [{ size = 100, storage = "samba-volume" }]
    }

    nfs = {
      count       = 1
      base_id     = 1070
      template_id = 1000
      tag_name    = "storage"
      storage     = local.common_vars.primary_disk.storage
      additional_disks = [
        { size = 100, storage = "monitoring-volume" },
        { size = 100, storage = "k8-volume" },
        { size = 100, storage = "other-volume" }
      ]
    }
    netforge = {
      count       = 1
      base_id     = 1020
      template_id = 1000
      tag_name    = "netforge"
      storage     = local.common_vars.primary_disk.storage
    }
    cicd = {
      count       = 1
      base_id     = 1030
      template_id = 1000
      tag_name    = "cicd"
      storage     = local.common_vars.primary_disk.storage
    }
    monitoring = {
      count       = 1
      template_id = 1000
      base_id     = 1040
      tag_name    = "monitoring"
      storage     = local.common_vars.primary_disk.storage
    }
    dev-tools = {
      count       = 1
      template_id = 1000
      base_id     = 1050
      tag_name    = "dev-tools"
      storage     = local.common_vars.primary_disk.storage
    }
    ldap = {
      count       = 1
      template_id = 1000
      base_id     = 1060
      tag_name    = "ldap"
      storage     = local.common_vars.primary_disk.storage
    }
  }

  # Flatten VM configurations
  vm_instances = flatten([
    for name, config in local.vms : [
      for i in range(config.count) : {
        name             = config.count == 1 ? name : "${name}-${i + 1}"
        vm_name          = config.count == 1 ? "${name}-server" : "${name}-server-${i + 1}"
        vm_id            = config.base_id + i
        tag_name         = config.tag_name
        template_id      = config.template_id
        primary_disk     = { size = local.common_vars.primary_disk.size, storage = config.storage }
        additional_disks = lookup(config, "additional_disks", [])
      }
    ]
  ])
}

# K8s cluster deployment
module "k8s_cluster" {
  source = "./modules/k8s"

  cluster_name   = "prod-cluster"
  master_count   = 3
  worker_count   = 3
  ha_count       = 0
  starting_vm_id = 1200

  vm_host      = local.common_vars.vm_host
  template_id  = 1000
  vm_cores     = 4
  vm_memory    = 8192
  primary_disk = local.common_vars.primary_disk
}

# testing cluster
module "k8s_cluster-testing" {
  source = "./modules/k8s"

  cluster_name   = "test-cluster"
  master_count   = 3
  worker_count   = 3
  ha_count       = 2
  starting_vm_id = 1400

  vm_host      = local.common_vars.vm_host
  template_id  = 1000
  vm_cores     = 4
  vm_memory    = 8192
  primary_disk = local.common_vars.primary_disk
}


# Standalone VMs deployment
module "standalone_vms" {
  source   = "./modules/vmsmith"
  for_each = { for vm in local.vm_instances : vm.name => vm }

  vm_name          = each.value.vm_name
  vm_id            = each.value.vm_id
  tag_name         = each.value.tag_name
  vm_host          = local.common_vars.vm_host
  vm_cores         = local.common_vars.vm_cores
  vm_memory        = local.common_vars.vm_memory
  template_id      = each.value.template_id
  primary_disk     = each.value.primary_disk
  additional_disks = each.value.additional_disks
}

# Inventory aggregation
module "aggregator" {
  source         = "./modules/aggregator"
  inventory_path = var.ansible_path

  k8s_clusters = {
    "prod" = {
      masters  = module.k8s_cluster.master_nodes
      workers  = module.k8s_cluster.worker_nodes
      ha_nodes = module.k8s_cluster.ha_nodes
    }
  }

  k8s_clusters-test = {
    "test" = {
      masters  = module.k8s_cluster.master_nodes
      workers  = module.k8s_cluster.worker_nodes
      ha_nodes = module.k8s_cluster.ha_nodes
    }
  }

  standalone_vms = {
    for name, vm in module.standalone_vms : name => {
      name         = vm.vm_name
      ip           = vm.vm_ip
      tags         = vm.vm_tags
      proxmox_host = vm.vm_host
    }
  }

  depends_on = [
    module.k8s_cluster,
    module.standalone_vms
  ]
}
