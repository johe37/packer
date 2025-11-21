locals {
  al9_vm_name = "almalinux9-base-image-${formatdate("YYYYMMDD", timestamp())}"
  al9_output_dir = "output/${local.al9_vm_name}"
  al9_format = "qcow2"
}

source "qemu" "almalinux9" {
  output_directory = local.al9_output_dir
  vm_name        = "${local.al9_vm_name}.${local.al9_format}"
  iso_url        = var.al9_iso_url
  iso_checksum   = var.al9_iso_checksum
  http_directory = "http"
  boot_wait      = "10s"
  boot_command = [
    "<tab> inst.text net.ifnames=0 inst.gpt inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/alma9-ks.cfg<enter><wait>",
  ]
  shutdown_command   = "/sbin/shutdown -hP now"
  accelerator        = "kvm"
  ssh_username       = "root"
  ssh_password       = "changeme"
  ssh_timeout        = "60m"
  disk_interface     = "virtio-scsi"
  disk_size          = "30G"
  disk_cache         = "none"
  disk_discard       = "unmap"
  disk_detect_zeroes = "unmap"
  disk_compression   = true
  format             = local.al9_format
  net_device         = "virtio-net"
  vnc_bind_address   = "0.0.0.0"
  vnc_port_min       = "5900"
  vnc_port_max       = "5910"
  qemuargs = [
    ["-m", "2048M"],
    ["-smp", "2"],
    ["-cpu", "host"]
  ]
  headless = true
}

build {
  sources = [
    "qemu.almalinux9",
  ]

  provisioner "ansible" {
    playbook_file    = "./ansible/provision-image-rhel.yml"
    ansible_env_vars = var.ansible_env_vars
  }

  provisioner "ansible" {
    playbook_file    = "./ansible/gather-metadata.yml"
    ansible_env_vars = var.ansible_env_vars
  }

  provisioner "file" {
    source      = "/tmp/metadata.json"
    destination = "${local.al9_output_dir}/metadata.json"
    direction   = "download"
  }

  provisioner "ansible" {
    playbook_file    = "./ansible/cleanup-rhel.yml"
    ansible_env_vars = var.ansible_env_vars
  }
}
