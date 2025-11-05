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
