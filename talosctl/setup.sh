!#/bin/bash

# Generate Machine Configurations
talosctl gen config --config-patch @patch.yaml talos-proxmox-cluster https://172.16.10.5:6443 --output-dir _out
talosctl get disks --insecure --nodes 172.16.10.5

# Create Control Plane Node
talosctl apply-config --insecure --nodes 172.16.10.5 --file _out/controlplane.yaml

talosctl gen config talos-proxmox-cluster https://172.16.10.5:6443 --output-dir _out --install-image factory.talos.dev/installer/ce4c980550dd2ab1b17bbf2b08801c7eb59418eafe8f279833297925d67c7515:v1.9.2


# Create Worker Nodes
talosctl apply-config  --insecure --nodes 172.16.10.6 --file _out/worker.yaml
talosctl apply-config  --insecure --nodes 172.16.10.7 --file _out/worker.yaml


# Using the Cluster
export TALOSCONFIG="_out/talosconfig" 
talosctl config endpoint 172.16.10.5
talosctl config node 172.16.10.5

# Must wait for reebot
sleep 60

talosctl bootstrap && helm repo add cilium https://helm.cilium.io/ && helm repo update && helm install \
    cilium \
    cilium/cilium \
    --version 1.15.6 \
    --namespace kube-system \
    --set ipam.mode=kubernetes \
    --set kubeProxyReplacement=false \
    --set securityContext.capabilities.ciliumAgent="{CHOWN,KILL,NET_ADMIN,NET_RAW,IPC_LOCK,SYS_ADMIN,SYS_RESOURCE,DAC_OVERRIDE,FOWNER,SETGID,SETUID}" \
    --set securityContext.capabilities.cleanCiliumState="{NET_ADMIN,SYS_ADMIN,SYS_RESOURCE}" \
    --set cgroup.autoMount.enabled=false \
    --set cgroup.hostRoot=/sys/fs/cgroup

talosctl kubeconfig /Users/julio/.kubeconfig 

# Set kubeconfig file
export KUBECONFIG=/Users/julio/.kubeconfig
