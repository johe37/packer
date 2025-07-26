# Packer

This is my Packer repo for building base images such as
AlmaLinux, Debian, Ubuntu etc.

## Get started

Before continuing, make sure that your user belongs to the kvm group.

```shell
sudo usermod -aG kvm $USER
```

Or, run packer with sudo (not recommended).

### Dependencies

```shell
git clone git@github.com:johe37/packer.git
cd packer

chmod +x scripts/setup
./scripts/setup
```

### Build

```shell
# Build all
packer init .
packer build .

# Build specific
packer build -only=qemu.debian12 .
```
