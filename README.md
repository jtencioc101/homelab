# Homelab Project (WIP)

Rationale:

My work exposes me to a lot of bleeding edge technologies and the best way to remain relevant in the field is trough constant practice and learning new stuff.

My homelab will help me to test and play around with emerging technologies and practice in a safe sandboxed self-managed space.

# Setup

Currently my home network is fully segregated via VLANS, all the devices such as laptops, phones and "smart devices" are in a network segment that allows just internet access. At the top of the network sits an Opnsense firewall that has specific rules for each network segment on what can or can't access.

# Virtualization

In the past months I self hosted some applications on Docker, each application was accessed via https using SSL certificates handled by a Traefik instance (also running on Docker).

I opted out to move to a virtualization environment in this case Proxmox to implement a Kubernetes cluster. The virtual environment will allow me to create three separate VM's that will host the K8s cluster.

# Kubernetes

After some research I opted out to use Talos Linux as a medium to deploy the Kubernetes cluster, as this specific distro is aimed to just run Kubernetes and offers a relative simple command line to prep each node as control plane and/or worker node.

# Configuration Management

I am using Terraform to keep and manage all my infrastructure as code in order to build and delete all the infra in a repeatable manner and avoid drifts in the configuration.

I will explore Ansible as a tool to automate all the cluster nodes in case I decide to rebuild the lab at some point.

