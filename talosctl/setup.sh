!#/bin/bash

# Generate Machine Configurations

talosctl gen config --config-patch @patch.yaml talos-proxmox-cluster https://172.16.10.16:6443 --output-dir _out
talosctl get disks --insecure --nodes 172.16.10.16

# Create Control Plane Node

talosctl apply-config --insecure --nodes 172.16.10.16 --file _out/controlplane.yaml

# Create Worker Nodes

talosctl apply-config  --insecure --nodes 172.16.10.17 --file _out/worker.yaml
talosctl apply-config  --insecure --nodes 172.16.10.18 --file _out/worker.yaml


# Using the Cluster

export TALOSCONFIG="_out/talosconfig" 
talosctl config endpoint 172.16.10.16
talosctl config node 172.16.10.16

# Must wait for reebot

sleep 60

talosctl bootstrap

talosctl kubeconfig /Users/julio/.kubeconfig 

# Set kubeconfig file

export KUBECONFIG=/Users/julio/.kubeconfig
