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
