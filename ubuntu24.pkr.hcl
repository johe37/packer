source "qemu" "ubuntu24" {
  output_directory = var.output_dir
  vm_name        = "ubuntu24-base-image.qcow2"
  iso_url        = "https://old-releases.ubuntu.com/releases/24.04.2/ubuntu-24.04.2-live-server-amd64.iso"
  iso_checksum   = "md5:d0013676be5d53a9a160abd3ca1f762f"
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
    "qemu.ubuntu24",
  ]

  provisioner "ansible" {
    playbook_file    = "./ansible/provision-image-debian.yml"
    ansible_env_vars = var.ansible_env_vars
  }
}

