[proxmox]
%{ for hostname, ip in proxmox_hosts ~}
${hostname} ansible_host=${ip}
%{ endfor ~}

[servers]
%{ for vm in values(standalone_vms) ~}
${vm.name} ansible_host=${vm.ip[0]} proxmox_host=${vm.proxmox_host}
%{ endfor ~}

%{ for tag in distinct(flatten([for vm in values(standalone_vms) : vm.tags])) ~}
%{ if tag != "terraform" ~}
[${tag}]
%{ for vm in values(standalone_vms) ~}
%{ if contains(vm.tags, tag) ~}
${vm.name}
%{ endif ~}
%{ endfor ~}
%{ endif ~}
%{ endfor ~}

[terraform:children]
servers
%{ if has_k8s ~}
%{ for cluster_name, cluster in k8s_clusters ~}
${cluster_name}_control_plane
${cluster_name}_workers
%{ if length(cluster.ha_nodes) > 0 ~}
${cluster_name}_ha
%{ endif ~}
%{ endfor ~}
%{ endif ~}
