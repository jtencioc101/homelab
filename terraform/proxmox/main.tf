resource "proxmox_virtual_environment_vm" "k8s-machines" {
  for_each = var.k8s-machines
  name        = each.value.name
  description = "Managed by Terraform"
  tags        = ["terraform", "talos"]

  node_name = "pve1"
  vm_id     = each.value.vmid

  agent {
    # read 'Qemu guest agent' section, change to true only when ready
    enabled = false #if this is set to true terraform destroy will not work
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
    dedicated = 8196
    floating  = 8196# set equal to dedicated to enable ballooning
  }

  disk {
    datastore_id = "Data"
    file_id      = proxmox_virtual_environment_download_file.talos_qemuagent_qcow2_img.id
    interface    = "scsi0"
  }

  initialization {
    ip_config {
      ipv4 {
        address = each.value.ip
        gateway = "172.16.10.1"
      }
    }

    dns {
      servers = ["172.16.10.2"]
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
  url          = "https://factory.talos.dev/image/ce4c980550dd2ab1b17bbf2b08801c7eb59418eafe8f279833297925d67c7515/v1.9.2/nocloud-amd64.iso"
}

