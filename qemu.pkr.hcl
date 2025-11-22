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

variable "ansible_env_vars" {
  type = list(string)
  default = [
    "ANSIBLE_SSH_ARGS='-o IdentitiesOnly=yes'",
    "ANSIBLE_PIPELINING=True",
    "ANSIBLE_REMOTE_TEMP=/tmp",
  ]
}

variable "output_dir" {
  type    = string
  default = "output"
}

# AlmaLinux 9
variable "al9_iso_url" {
  type = string
  default = "https://mirror.bahnhof.net/pub/almalinux/9.7/isos/x86_64/AlmaLinux-9.7-x86_64-boot.iso"
}
variable "al9_iso_checksum" {
  type = string
  default = "sha256:494d09f608b325ef42899b5ce38ba1b17755a639f5558b9b98a031b0696e694a"
}

# Debian 12
variable "debian12_iso_url" {
  type = string
  default = "https://cdimage.debian.org/cdimage/archive/12.12.0/amd64/iso-cd/debian-12.12.0-amd64-netinst.iso"
}
variable "debian12_iso_checksum" {
  type = string
  default = "sha512:c93055182057dd19a334260671c7e10880541b7721ad9c8df87be47e0a11d5bbf85018350ff224ff6a5f6a68320b07e95d539cef9dc020c93966bfaa86d4b2ce"
}

# Debian 13
variable "debian13_iso_url" {
  type = string
  default = "https://cdimage.debian.org/cdimage/archive/13.1.0/amd64/iso-cd/debian-13.1.0-amd64-netinst.iso"
}
variable "debian13_iso_checksum" {
  type = string
  default = "sha256:658b28e209b578fe788ec5867deebae57b6aac5fce3692bbb116bab9c65568b3"
}

# Ubuntu 24
variable "ubuntu24_iso_url" {
  type = string
  default = "https://old-releases.ubuntu.com/releases/24.04.2/ubuntu-24.04.2-live-server-amd64.iso"
}
variable "ubuntu24_iso_checksum" {
  type = string
  default = "md5:d0013676be5d53a9a160abd3ca1f762f"
}
