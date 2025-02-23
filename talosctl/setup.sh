!#/bin/bash

# Generate Machine Configurations
talosctl gen config talos-proxmox-cluster https://k8s-ccp:6443 --output-dir _out
talosctl get disks --insecure --nodes k8s-ccp

# Create Control Plane Node
talosctl apply-config --insecure --nodes k8s-ccp --file _out/controlplane.yaml

# Create Worker Nodes
talosctl apply-config --insecure --nodes k8s-node01 --file _out/worker.yaml
talosctl apply-config --insecure --nodes k8s-node02 --file _out/worker.yaml


# Using the Cluster
export TALOSCONFIG="_out/talosconfig" 
talosctl config endpoint k8s-ccp
talosctl config node k8s-ccp
talosctl bootstrap
talosctl kubeconfig ~/.kubeconfig

# Set kubeconfig file
export KUBECONFIG="~/.kubeconfig"
