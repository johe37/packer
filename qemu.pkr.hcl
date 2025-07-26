packer {
  required_version = ">= 1.8.0, < 2.0.0"
  required_plugins {
    qemu = {
      source  = "github.com/hashicorp/qemu"
      version = ">= 1.0.9"
    }
    ansible = {
      version = ">=1.0.0"
      source  = "github.com/hashicorp/ansible"
    }
  }
}

# AlmaLinux9
source "qemu" "almalinux9" {
  iso_url        = "https://raw.repo.almalinux.org/almalinux/9/isos/x86_64/AlmaLinux-9.6-x86_64-boot.iso"
  iso_checksum   = "sha256:113521ec7f28aa4ab71ba4e5896719da69a0cc46cf341c4ebbd215877214f661"
  vm_name        = "packer-almalinux9.qcow2"
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
  format             = "qcow2"
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

# Debian12
source "qemu" "debian12" {
  iso_url        = "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12.11.0-amd64-netinst.iso"
  iso_checksum   = "sha512:0921d8b297c63ac458d8a06f87cd4c353f751eb5fe30fd0d839ca09c0833d1d9934b02ee14bbd0c0ec4f8917dde793957801ae1af3c8122cdf28dde8f3c3e0da"
  vm_name        = "packer-debian12.qcow2"
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

# Ubuntu24
source "qemu" "ubuntu24" {
  iso_url        = "https://releases.ubuntu.com/noble/ubuntu-24.04.2-live-server-amd64.iso"
  iso_checksum   = "md5:d0013676be5d53a9a160abd3ca1f762f"
  vm_name        = "packer-ubuntu24.qcow2"
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

# Shared Ansible provisioner (you can customize per build if needed)
locals {
  ansible_env_vars = [
    "ANSIBLE_SSH_ARGS='-o IdentitiesOnly=yes'",
    "ANSIBLE_PIPELINING=True",
    "ANSIBLE_REMOTE_TEMP=/tmp",
  ]
}

# AlmaLinux9 build block
build {
  sources = [
    "qemu.almalinux9",
  ]

  provisioner "ansible" {
    playbook_file    = "files/provision-image-rhel.yml"
    ansible_env_vars = local.ansible_env_vars
  }
}

# Debian12 build block
build {
  sources = [
    "qemu.debian12",
  ]

  provisioner "ansible" {
    playbook_file    = "files/provision-image-debian.yml"
    ansible_env_vars = local.ansible_env_vars
  }
}

# Ubuntu24 build block
build {
  sources = [
    "qemu.ubuntu24",
  ]

  provisioner "ansible" {
    playbook_file    = "files/provision-image-debian.yml"
    ansible_env_vars = local.ansible_env_vars
  }
}
