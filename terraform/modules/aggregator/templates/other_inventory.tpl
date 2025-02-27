%{ if has_other ~}
%{ for cluster_name, cluster_obj in other_clusters ~}
[${cluster_name}]
%{ for node_name, node in cluster_obj.nodes ~}
${node.name} ansible_host=${node.ip[0]} proxmox_host=${node.proxmox_host[0]}
%{ endfor ~}
%{ endfor ~}
%{ endif ~}

