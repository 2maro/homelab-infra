[proxmox]
${vm_host} ansible_host=${vm_host_ip}

%{ if has_standalone ~}
%{ for tag in distinct(flatten([for vm in values(standalone_vms) : vm.tags])) ~}
[${tag}]
%{ for vm in values(standalone_vms) ~}
%{ if contains(vm.tags, tag) ~}
${vm.name} ansible_host=${vm.ip[0]} proxmox_host=${vm.proxmox_host}
%{ endif ~}
%{ endfor ~}

%{ endfor ~}
%{ endif ~}

[terraform:children]
%{ if has_k8s ~}
%{ for cluster_name, cluster in k8s_clusters ~}
${cluster_name}_control_plane
${cluster_name}_workers
%{ if length(cluster.ha_nodes) > 0 ~}
${cluster_name}_ha
%{ endif ~}
%{ endfor ~}
%{ endif ~}
%{ for tag in distinct(flatten([for vm in values(standalone_vms) : vm.tags])) ~}
%{ if tag != "terraform" ~}
${tag}
%{ endif ~}
%{ endfor ~}