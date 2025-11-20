source "qemu" "almalinux9" {
  output_directory = var.output_dir
  vm_name        = "almalinux9-base-image-${formatdate("YYYYMMDD", timestamp())}.qcow2"
  iso_url        = "https://raw.repo.almalinux.org/almalinux/9/isos/x86_64/AlmaLinux-9.6-x86_64-boot.iso"
  iso_checksum   = "sha256:113521ec7f28aa4ab71ba4e5896719da69a0cc46cf341c4ebbd215877214f661"
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

build {
  sources = [
    "qemu.almalinux9",
  ]

  provisioner "ansible" {
    playbook_file    = "./ansible/provision-image-rhel.yml"
    ansible_env_vars = var.ansible_env_vars
  }
}

