# Lab 01: Linux Network Basics and Host Stack Visibility - Step-by-Step Guide

## Lab Path

- Working directory reference: `labs/lab_01_linux_network_basics`
- Validation script: `labs/lab_01_linux_network_basics/validation_script.sh`

## Prerequisites

- Ubuntu Server LTS terminal access
- `sudo` permissions for namespaces/firewall/capture tasks
- Recommended packages installed (see `README.md` and `environment/ubuntu_lab_setup.md`)

## Setup Commands (Exact)

```bash
mkdir -p /tmp/lab01
sudo ip netns add lab01-peer
sudo ip link add veth-l01 type veth peer name veth-l01p
sudo ip link set veth-l01p netns lab01-peer
sudo ip addr add 10.1.1.1/24 dev veth-l01
sudo ip link set veth-l01 up
sudo ip netns exec lab01-peer ip addr add 10.1.1.2/24 dev veth-l01p
sudo ip netns exec lab01-peer ip link set lo up
sudo ip netns exec lab01-peer ip link set veth-l01p up
```

## Execution Steps

### Step 1: Inspect local interface, address, and route state

**Exact commands**

```bash
ip link show veth-l01
ip addr show veth-l01
ip route show table main | head -20
```

**Expected terminal output**

Expected output snippets:
- `veth-l01` state is `UP`
- Address shows `10.1.1.1/24`
- Route table includes `10.1.1.0/24 dev veth-l01 scope link`

**What is happening internally (network stack perspective)**

The kernel will only consider the interface for forwarding local packets when link state and Layer 3 addressing are present; route entries are consulted before any ARP or transport processing.

### Step 2: Test reachability and observe neighbor cache population

**Exact commands**

```bash
ping -c 2 10.1.1.2
ip neigh show dev veth-l01
```

**Expected terminal output**

Expected output snippets:
- `2 packets transmitted, 2 received`
- Neighbor entry for `10.1.1.2` with state like `REACHABLE` or `STALE`

**What is happening internally (network stack perspective)**

On the first ping, Linux resolves the peer MAC via ARP, caches it in the neighbor table, then sends ICMP echo frames using Ethernet encapsulation over the veth interface.

### Step 3: Inspect sockets and link symptoms to application state

**Exact commands**

```bash
ss -tulpn | head -20
sudo ip netns exec lab01-peer python3 -m http.server 8080 >/tmp/lab01/http.log 2>&1 &
curl -sI http://10.1.1.2:8080 | head -5
ss -tan | grep ':8080' || true
```

**Expected terminal output**

Expected output snippets:
- `curl` returns `HTTP/1.0 200 OK`
- `ss` shows TCP sessions involving port `8080`

**What is happening internally (network stack perspective)**

A successful TCP connection confirms route selection, ARP, and transport establishment; the HTTP response confirms the application layer is reachable and listening.

## Intentional Misconfiguration Scenario (Required)

Intentional misconfiguration: bring `veth-l01` down on the host side and re-test connectivity.

```bash
sudo ip link set veth-l01 down
ping -c 2 10.1.1.2
ip link show veth-l01
sudo ip link set veth-l01 up
```

Expected outcome:

- Ping fails with 100% packet loss; `ip link` shows interface state `DOWN` until restored.

## Real-World Operational Failure Simulation (Required)

Real-world simulation: HTTP service process exits unexpectedly in the peer namespace while the network path remains healthy.

```bash
sudo pkill -f 'python3 -m http.server 8080' || true
ping -c 2 10.1.1.2
curl -sI --max-time 3 http://10.1.1.2:8080 || true
ss -tulpn | grep 8080 || true
```

## Debugging Walkthrough (Required)

1. Prove Layer 2/3 path still works with `ping -c 2 10.1.1.2`.
2. Check for a listener with `sudo ip netns exec lab01-peer ss -tulpn | grep 8080`.
3. Restart the service and retry `curl`.

## Permission / Safety Notes

- `sudo` is required for network namespace creation, `iptables`, and `tcpdump` in most environments.
- If connected remotely, avoid applying host firewall changes outside namespaces unless you have console recovery access.
- Privileged ports (for example `53`, `80`) may require root-owned processes depending on the command used.
