# Ubuntu Lab Setup (Fresh LTS VM)

## Goal

Prepare a clean Ubuntu Server LTS VM for all labs in this repository with minimal extra dependencies.

## Verified Environment Assumptions

- Ubuntu Server LTS
- Shell access via local console or VS Code terminal
- `sudo` privileges
- Single NIC is sufficient for most labs; Linux namespaces are used for multi-node simulation where applicable

## Setup Commands

```bash
sudo apt update
sudo apt install -y iproute2 iputils-ping dnsutils net-tools traceroute tcpdump ufw iptables iptables-persistent wireguard-tools curl jq netcat-openbsd
sudo systemctl enable --now systemd-resolved || true
```

Expected output:

- Package installation completes without dependency errors
- `systemd-resolved` active on systems that use it

## Optional Tools (Nice to Have)

```bash
sudo apt install -y mtr-tiny ethtool bridge-utils conntrack
```

## Permissions Notes

- `tcpdump` generally requires `sudo`
- Binding to privileged ports (`<1024`) requires `sudo` or capabilities
- Firewall/NAT labs require root privileges and can break remote connectivity if run on a shared VM

## Troubleshooting Section

### `apt update` fails

- Check DNS first: `getent hosts archive.ubuntu.com`
- Check default route: `ip route`
- Check time sync if TLS errors occur: `timedatectl`
