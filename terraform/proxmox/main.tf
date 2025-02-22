resource "proxmox_virtual_environment_vm" "k8s-machines" {
  for_each = var.vms
  name        = each.value.vm_name
  description = "Managed by Terraform"
  tags        = ["terraform", "talos"]

  node_name = "pve1"
  vm_id     = each.value.vm_id

  agent {
    # read 'Qemu guest agent' section, change to true only when ready
    enabled = true
  }
  # if agent is not enabled, the VM may not be able to shutdown properly, and may need to be forced off
  stop_on_destroy = true

  startup {
    order      = "1"
    up_delay   = "60"
    down_delay = "60"
  }

  cpu {
    cores        = 2
    type         = "x86-64-v2-AES"  # recommended for modern CPUs
  }

  memory {
    dedicated = 4096
    floating  = 4096 # set equal to dedicated to enable ballooning
  }

  disk {
    datastore_id = "local-lvm"
    file_id      = proxmox_virtual_environment_download_file.talos_qemuagent_qcow2_img.id
    interface    = "scsi0"
  }

  initialization {
    ip_config {
      ipv4 {
        address = each.value.vm_ip
        gateway = "172.16.10.1"
      }
    }

    user_account {
      #keys     = [trimspace(tls_private_key.ubuntu_vm_key.public_key_openssh)]
      password = var.adminpass
      username = var.adminuser
    }

   # user_data_file_id = proxmox_virtual_environment_file.cloud_config.id
  }

  network_device {
    bridge = "vmbr0"
  }

  operating_system {
    type = "l26"
  }

  tpm_state {
    version = "v2.0"
  }

  serial_device {}
}

resource "proxmox_virtual_environment_download_file" "talos_qemuagent_qcow2_img" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = "pve1"
  url          = "https://factory.talos.dev/image/ce4c980550dd2ab1b17bbf2b08801c7eb59418eafe8f279833297925d67c7515/v1.9.4/nocloud-amd64.iso"
}

#resource "random_password" "ubuntu_vm_password" {
# length           = 16
#  override_special = "_%@"
#  special          = true
#}

#resource "tls_private_key" "ubuntu_vm_key" {
#  algorithm = "RSA"
#  rsa_bits  = 2048
#}

#output "ubuntu_vm_password" {
#  value     = random_password.ubuntu_vm_password.result
#  sensitive = true
#}

#output "ubuntu_vm_private_key" {
#  value     = tls_private_key.ubuntu_vm_key.private_key_pem
#  sensitive = true
#}

#output "ubuntu_vm_public_key" {
#  value = tls_private_key.ubuntu_vm_key.public_key_openssh
#}
