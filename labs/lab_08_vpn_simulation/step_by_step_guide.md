# Lab 08: WireGuard VPN Simulation (Conceptual + Linux Configuration Validation) - Step-by-Step Guide

## Lab Path

- Working directory reference: `labs/lab_08_vpn_simulation`
- Validation script: `labs/lab_08_vpn_simulation/validation_script.sh`

## Prerequisites

- Ubuntu Server LTS terminal access
- `sudo` permissions for namespaces/firewall/capture tasks
- Recommended packages installed (see `README.md` and `environment/ubuntu_lab_setup.md`)

## Setup Commands (Exact)

```bash
sudo apt install -y wireguard-tools >/dev/null
mkdir -p /tmp/lab08
cat > /tmp/lab08/wg0.conf <<'CFG'
[Interface]
Address = 10.99.8.1/24
ListenPort = 51820
PrivateKey = qYHBGFX+Xq5sM8VvVQ4S4KfVJQ1wQ8YJkQn4M2h4aUQ=

[Peer]
PublicKey = U0aH1rQ5tR4dKj8G8z6pLwq8v7L5sV1X2m9FqT0aN3o=
Endpoint = 198.51.100.10:51820
AllowedIPs = 10.99.8.2/32, 10.88.0.0/24
PersistentKeepalive = 25
CFG
```

## Execution Steps

### Step 1: Validate WireGuard configuration structure and route intent

**Exact commands**

```bash
grep -E '^(\[|Address|ListenPort|Endpoint|AllowedIPs)' /tmp/lab08/wg0.conf
awk -F' = ' '/AllowedIPs/ {print $2}' /tmp/lab08/wg0.conf
```

**Expected terminal output**

Expected output snippets:
- Interface and Peer sections present
- `AllowedIPs` lists tunnel peer and remote subnet(s)

**What is happening internally (network stack perspective)**

In WireGuard, `AllowedIPs` functions as both traffic selector and route policy, so mistakes here often appear as routing failures rather than crypto failures.

### Step 2: Generate real keys locally and replace the example keys (safe local test)

**Exact commands**

```bash
umask 077
wg genkey | tee /tmp/lab08/server.key | wg pubkey > /tmp/lab08/server.pub
wg genkey | tee /tmp/lab08/client.key | wg pubkey > /tmp/lab08/client.pub
ls -l /tmp/lab08/*.key /tmp/lab08/*.pub
```

**Expected terminal output**

Expected output snippets:
- Key files exist with restricted permissions (e.g. `-rw-------` for private keys)

**What is happening internally (network stack perspective)**

WireGuard uses Curve25519 keys; private key protection matters because anyone with the key can impersonate the peer.

### Step 3: Validate interface and route checks you will use in a real deployment

**Exact commands**

```bash
echo 'Planned runtime checks:'
echo 'sudo wg show'
echo 'ip addr show wg0'
echo 'ip route show | grep wg0'
echo 'sudo tcpdump -ni any udp port 51820'
```

**Expected terminal output**

Expected output snippets:
- A checklist of runtime verification commands for production troubleshooting

**What is happening internally (network stack perspective)**

These commands validate the transport path (UDP/51820), tunnel interface state, and route injection behavior independently.

## Intentional Misconfiguration Scenario (Required)

Intentional misconfiguration: set `AllowedIPs = 0.0.0.0/0` unintentionally when only a remote subnet is desired.

```bash
sed -i 's/AllowedIPs = .*/AllowedIPs = 0.0.0.0\/0/' /tmp/lab08/wg0.conf
grep '^AllowedIPs' /tmp/lab08/wg0.conf
# Restore expected scoped routes
sed -i 's#AllowedIPs = 0.0.0.0/0#AllowedIPs = 10.99.8.2/32, 10.88.0.0/24#' /tmp/lab08/wg0.conf
```

Expected outcome:

- Config now indicates a full-tunnel route selection, which would redirect all traffic in a real deployment if applied.

## Real-World Operational Failure Simulation (Required)

Real-world simulation: handshake observed, but remote subnet unreachable because `AllowedIPs` excludes the remote LAN prefix.

```bash
sed -i 's/10.88.0.0\/24//' /tmp/lab08/wg0.conf
grep '^AllowedIPs' /tmp/lab08/wg0.conf
echo 'In a live system, `ip route get 10.88.0.10` would fail to select wg0.'
```

## Debugging Walkthrough (Required)

1. Inspect `AllowedIPs` first when reachability to remote subnets fails.
2. Check `wg show` for recent handshake to separate transport vs routing/policy issues.
3. Validate host firewall and forwarding rules if acting as a VPN gateway.

## Permission / Safety Notes

- `sudo` is required for network namespace creation, `iptables`, and `tcpdump` in most environments.
- If connected remotely, avoid applying host firewall changes outside namespaces unless you have console recovery access.
- Privileged ports (for example `53`, `80`) may require root-owned processes depending on the command used.
