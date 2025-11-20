source "qemu" "debian12" {
  output_directory = var.output_dir
  vm_name        = "debian12-base-image.qcow2"
  iso_url        = "https://cdimage.debian.org/cdimage/archive/12.12.0/amd64/iso-cd/debian-12.12.0-amd64-netinst.iso"
  iso_checksum   = "sha512:c93055182057dd19a334260671c7e10880541b7721ad9c8df87be47e0a11d5bbf85018350ff224ff6a5f6a68320b07e95d539cef9dc020c93966bfaa86d4b2ce"
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
  format           = "qcow2"
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
    "qemu.debian12",
  ]

  provisioner "ansible" {
    playbook_file    = "./ansible/provision-image-debian.yml"
    ansible_env_vars = var.ansible_env_vars
  }
}

