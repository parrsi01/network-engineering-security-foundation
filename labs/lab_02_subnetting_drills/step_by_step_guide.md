# Lab 02: Subnetting Drills with Reachability Consequences - Step-by-Step Guide

## Lab Path

- Working directory reference: `labs/lab_02_subnetting_drills`
- Validation script: `labs/lab_02_subnetting_drills/validation_script.sh`

## Prerequisites

- Ubuntu Server LTS terminal access
- `sudo` permissions for namespaces/firewall/capture tasks
- Recommended packages installed (see `README.md` and `environment/ubuntu_lab_setup.md`)

## Setup Commands (Exact)

```bash
sudo ip netns add l2a
sudo ip netns add l2b
sudo ip link add br-l02 type bridge
sudo ip link set br-l02 up
sudo ip link add veth-l02a type veth peer name veth-l02a-ns
sudo ip link add veth-l02b type veth peer name veth-l02b-ns
sudo ip link set veth-l02a master br-l02
sudo ip link set veth-l02b master br-l02
sudo ip link set veth-l02a up
sudo ip link set veth-l02b up
sudo ip link set veth-l02a-ns netns l2a
sudo ip link set veth-l02b-ns netns l2b
sudo ip netns exec l2a ip link set lo up
sudo ip netns exec l2b ip link set lo up
sudo ip netns exec l2a ip link set veth-l02a-ns up
sudo ip netns exec l2b ip link set veth-l02b-ns up
sudo ip netns exec l2a ip addr add 192.168.50.10/24 dev veth-l02a-ns
sudo ip netns exec l2b ip addr add 192.168.50.20/24 dev veth-l02b-ns
```

## Execution Steps

### Step 1: Verify connectivity with correct subnet masks

**Exact commands**

```bash
sudo ip netns exec l2a ping -c 2 192.168.50.20
sudo ip netns exec l2a ip route get 192.168.50.20
sudo ip netns exec l2a ip neigh show
```

**Expected terminal output**

Expected output snippets:
- Ping succeeds (2/2 replies)
- Route lookup shows `dev veth-l02a-ns` (directly connected)
- Neighbor table contains MAC for `192.168.50.20`

**What is happening internally (network stack perspective)**

With `/24` on both sides, the kernel treats the destination as on-link, so it ARPs directly instead of looking for a gateway.

### Step 2: Introduce mask mismatch and observe route/ARP behavior

**Exact commands**

```bash
sudo ip netns exec l2a ip addr flush dev veth-l02a-ns
sudo ip netns exec l2a ip addr add 192.168.50.10/25 dev veth-l02a-ns
sudo ip netns exec l2a ip route get 192.168.50.200 || true
sudo ip netns exec l2a ping -c 2 192.168.50.20
```

**Expected terminal output**

Expected output snippets:
- `192.168.50.20` still reachable (same lower /25)
- Addresses in the upper half (e.g. `.200`) are treated as off-link and may show `Network is unreachable` without a gateway

**What is happening internally (network stack perspective)**

The prefix length changes the connected route boundary. Linux decides local vs remote before sending any ARP request or transport traffic.

### Step 3: Run quick subnetting validation drills in terminal

**Exact commands**

```bash
python3 - <<'PY'
import ipaddress
for cidr in ['192.168.50.10/25', '10.20.30.65/27', '172.16.4.130/26']:
iface = ipaddress.ip_interface(cidr)
net = iface.network
print(f'{cidr} -> net={net.network_address} bcast={net.broadcast_address} hosts={net.num_addresses-2}')
PY
```

**Expected terminal output**

Expected output snippets:
- `192.168.50.10/25 -> net=192.168.50.0 bcast=192.168.50.127 hosts=126`
- `10.20.30.65/27 -> net=10.20.30.64 bcast=10.20.30.95 hosts=30`

**What is happening internally (network stack perspective)**

These calculations define the connected route the kernel installs, which directly affects next-hop selection and ARP behavior.

## Intentional Misconfiguration Scenario (Required)

Intentional misconfiguration: set `l2b` to `192.168.50.20/25` and move it into the upper subnet (`192.168.50.200/25`) while `l2a` remains in lower `/25`.

```bash
sudo ip netns exec l2b ip addr flush dev veth-l02b-ns
sudo ip netns exec l2b ip addr add 192.168.50.200/25 dev veth-l02b-ns
sudo ip netns exec l2a ping -c 2 192.168.50.200 || true
sudo ip netns exec l2a ip route get 192.168.50.200 || true
```

Expected outcome:

- Ping fails; route lookup shows the destination is no longer on-link from `l2a` without a configured gateway.

## Real-World Operational Failure Simulation (Required)

Real-world simulation: a manually assigned host is deployed with `/25` instead of `/24`, causing partial reachability to some peers and false assumptions about switch failure.

```bash
sudo ip netns exec l2a ip addr show dev veth-l02a-ns
sudo ip netns exec l2a ip route show
sudo ip netns exec l2a ping -c 2 192.168.50.20
sudo ip netns exec l2a ping -c 2 192.168.50.200 || true
```

## Debugging Walkthrough (Required)

1. List interface IP/prefix and confirm the actual mask on each host.
2. Use `ip route get <peer_ip>` to see whether Linux treats the destination as on-link or off-link.
3. Correct the prefix length and re-test pings to both lower and upper address ranges.

## Permission / Safety Notes

- `sudo` is required for network namespace creation, `iptables`, and `tcpdump` in most environments.
- If connected remotely, avoid applying host firewall changes outside namespaces unless you have console recovery access.
- Privileged ports (for example `53`, `80`) may require root-owned processes depending on the command used.
