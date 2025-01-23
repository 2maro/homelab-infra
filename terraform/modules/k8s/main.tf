locals {
  master_nodes = var.master_count > 0 ? {
    for i in range(1, var.master_count + 1) : "master${i}" => {
      vm_name     = format("%s-master-%d", var.cluster_name, i)
      vm_id       = var.starting_vm_id + i
      tags        = ["k8s-master", var.cluster_name]
      promox_host = var.vm_host
    }
  } : {}

  worker_nodes = var.worker_count > 0 ? {
    for i in range(1, var.worker_count + 1) : "worker${i}" => {
      vm_name     = format("%s-worker-%d", var.cluster_name, i)
      vm_id       = var.starting_vm_id + var.master_count + i
      tags        = ["k8s-worker", var.cluster_name]
      promox_host = var.vm_host
    }
  } : {}

  ha_nodes = var.ha_count > 0 ? {
    for i in range(1, var.ha_count + 1) : "ha${i}" => {
      vm_name     = format("%s-ha-%d", var.cluster_name, i)
      vm_id       = var.starting_vm_id + var.master_count + var.worker_count + i
      tags        = ["k8s-ha", var.cluster_name]
      promox_host = var.vm_host
    }
  } : {}

  common_config = {
    vm_cores        = var.vm_cores
    vm_memory       = var.vm_memory
    vm_machine_type = var.vm_machine_type
    vm_host         = var.vm_host
    primary_disk    = var.primary_disk
    template_id     = var.template_id
    boot_on         = var.boot_on
  }
}

module "masters" {
  source   = "../vmsmith"
  for_each = local.master_nodes

  vm_name         = each.value.vm_name
  vm_id           = each.value.vm_id
  tag_name        = each.value.tags[0]
  vm_cores        = local.common_config.vm_cores
  vm_memory       = local.common_config.vm_memory
  vm_machine_type = local.common_config.vm_machine_type
  vm_host         = local.common_config.vm_host
  template_id     = local.common_config.template_id
  boot_on         = local.common_config.boot_on
  primary_disk    = local.common_config.primary_disk

}

module "workers" {
  source   = "../vmsmith"
  for_each = local.worker_nodes

  vm_name         = each.value.vm_name
  vm_id           = each.value.vm_id
  tag_name        = each.value.tags[0]
  vm_cores        = local.common_config.vm_cores
  vm_memory       = local.common_config.vm_memory
  vm_machine_type = local.common_config.vm_machine_type
  vm_host         = local.common_config.vm_host
  template_id     = local.common_config.template_id
  boot_on         = local.common_config.boot_on
  primary_disk    = local.common_config.primary_disk

}

module "ha_nodes" {
  source   = "../vmsmith"
  for_each = local.ha_nodes

  vm_name         = each.value.vm_name
  vm_id           = each.value.vm_id
  tag_name        = each.value.tags[0]
  vm_cores        = local.common_config.vm_cores
  vm_memory       = local.common_config.vm_memory
  vm_machine_type = local.common_config.vm_machine_type
  vm_host         = local.common_config.vm_host
  template_id     = local.common_config.template_id
  boot_on         = local.common_config.boot_on
  primary_disk    = local.common_config.primary_disk

}
