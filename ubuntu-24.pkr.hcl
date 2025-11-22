locals {
  ubuntu24_vm_name = "ubuntu-24-base-image-${formatdate("YYYYMMDD", timestamp())}"
  ubuntu24_output_dir = "output/${local.ubuntu24_vm_name}"
  ubuntu24_format = "qcow2"
}

source "qemu" "ubuntu-24" {
  output_directory = local.ubuntu24_output_dir
  vm_name        = "${local.ubuntu24_vm_name}.${local.ubuntu24_format}"
  iso_url        = var.ubuntu24_iso_url
  iso_checksum   = var.ubuntu24_iso_checksum
  http_directory = "http"
  boot_wait      = "10s"
  boot_command = [
    "<esc><wait>",
    "e<wait>",
    "<down><down><down><end>",
    "<bs><bs><bs><bs><wait>",
    "autoinstall ds=nocloud-net\\;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ ---<wait>",
    "<f10><wait>"
  ]
  accelerator      = "kvm"
  disk_interface   = "virtio-scsi"
  disk_size        = "10G"
  disk_cache       = "none"
  disk_discard     = "unmap"
  disk_compression = true
  format           = local.ubuntu24_format
  net_device       = "virtio-net"
  qemuargs = [
    ["-m", "2048M"],
    ["-smp", "2"],
    ["-cpu", "host"]
  ]
  ssh_username     = "root"
  ssh_password     = "changeme"
  ssh_timeout      = "30m"
  headless         = true
  vnc_bind_address = "0.0.0.0"
  vnc_port_min     = "5900"
  vnc_port_max     = "5910"
}

build {
  sources = [
    "qemu.ubuntu-24",
  ]

  provisioner "ansible" {
    playbook_file    = "./ansible/provision-image-debian.yml"
    ansible_env_vars = var.ansible_env_vars
  }

  provisioner "ansible" {
    playbook_file    = "./ansible/gather-metadata.yml"
    ansible_env_vars = var.ansible_env_vars
  }

  provisioner "file" {
    source      = "/tmp/metadata.json"
    destination = "${local.ubuntu24_output_dir}/metadata.json"
    direction   = "download"
  }

  provisioner "ansible" {
    playbook_file    = "./ansible/cleanup-debian.yml"
    ansible_env_vars = var.ansible_env_vars
  }
}
