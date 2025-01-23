%{ if has_k8s ~}
%{ for cluster_name, cluster in k8s_clusters ~}

[${cluster_name}_control_plane]
%{ for master in cluster.masters ~}
${master.name} ansible_host=${master.ip[0]} proxmox_host=${master.proxmox_host[0]}
%{ endfor ~}

[${cluster_name}_workers]
%{ for worker in cluster.workers ~}
${worker.name} ansible_host=${worker.ip[0]} proxmox_host=${worker.proxmox_host[0]}
%{ endfor ~}

%{ if length(cluster.ha_nodes) > 0 ~}
[${cluster_name}_ha]
%{ for ha in cluster.ha_nodes ~}
${ha.name} ansible_host=${ha.ip[0]} proxmox_host=${ha.proxmox_host[0]}
%{ endfor ~}
%{ endif ~}

[k8s:children]
${cluster_name}_control_plane
${cluster_name}_workers
%{ if length(cluster.ha_nodes) > 0 ~}
${cluster_name}_ha
%{ endif ~}

%{ endfor ~}
%{ endif ~}