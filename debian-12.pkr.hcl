locals {
  debian12_vm_name = "debian-12-base-image-${formatdate("YYYYMMDD", timestamp())}"
  debian12_output_dir = "output/${local.debian12_vm_name}"
  debian12_format = "qcow2"
}

source "qemu" "debian-12" {
  output_directory = local.debian12_output_dir
  vm_name        = "${local.debian12_vm_name}.${local.debian12_format}"
  iso_url        = var.debian12_iso_url
  iso_checksum   = var.debian12_iso_checksum
  http_directory = "http"
  boot_wait      = "10s"
  boot_command = [
    "<esc><wait>auto url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg<enter>"
  ]
  accelerator      = "kvm"
  disk_interface   = "virtio-scsi"
  disk_size        = "10G"
  disk_cache       = "none"
  disk_discard     = "unmap"
  disk_compression = true
  format           = local.debian12_format
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
    "qemu.debian-12",
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
    destination = "${local.debian12_output_dir}/metadata.json"
    direction   = "download"
  }

  provisioner "ansible" {
    playbook_file    = "./ansible/cleanup-debian.yml"
    ansible_env_vars = var.ansible_env_vars
  }
}
