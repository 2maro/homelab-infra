[proxmox]
%{ for hostname, ip in proxmox_hosts ~}
${hostname} ansible_host=${ip}
%{ endfor ~}

%{ if has_standalone ~}
[servers]
%{ for vm in values(standalone_vms) ~}
${vm.name} ansible_host=${vm.ip[0]} proxmox_host=${vm.proxmox_host}
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

