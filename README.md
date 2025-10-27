# Packer

This is my Packer repo for building base images such as
AlmaLinux, Debian, Ubuntu etc.

## Get started

### Dependencies

```shell
git clone git@github.com:johe37/packer.git
cd packer

chmod +x scripts/setup
./scripts/setup
```

Before continuing, make sure that your user belongs to the kvm group.

```shell
sudo usermod -aG kvm $USER
```

Or, run packer with sudo (not recommended).

### Build

```shell
# Build all
packer init .
packer build .

# Build specific
packer build -only=qemu.debian12 .
```

### Setup noVNC example

```shell
sudo novnc_proxy --vnc localhost:5900 --listen 6080
```
