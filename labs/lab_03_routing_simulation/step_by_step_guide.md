# Lab 03: Routing Simulation with Linux Namespaces - Step-by-Step Guide

## Lab Path

- Working directory reference: `labs/lab_03_routing_simulation`
- Validation script: `labs/lab_03_routing_simulation/validation_script.sh`

## Prerequisites

- Ubuntu Server LTS terminal access
- `sudo` permissions for namespaces/firewall/capture tasks
- Recommended packages installed (see `README.md` and `environment/ubuntu_lab_setup.md`)

## Setup Commands (Exact)

```bash
sudo ip netns add r3-client
sudo ip netns add r3-router
sudo ip netns add r3-server
sudo ip link add r3c type veth peer name r3c-r
sudo ip link add r3s type veth peer name r3s-r
sudo ip link set r3c netns r3-client
sudo ip link set r3c-r netns r3-router
sudo ip link set r3s netns r3-server
sudo ip link set r3s-r netns r3-router
sudo ip netns exec r3-client ip link set lo up
sudo ip netns exec r3-router ip link set lo up
sudo ip netns exec r3-server ip link set lo up
sudo ip netns exec r3-client ip addr add 10.10.30.10/24 dev r3c
sudo ip netns exec r3-router ip addr add 10.10.30.1/24 dev r3c-r
sudo ip netns exec r3-server ip addr add 10.20.30.10/24 dev r3s
sudo ip netns exec r3-router ip addr add 10.20.30.1/24 dev r3s-r
sudo ip netns exec r3-client ip link set r3c up
sudo ip netns exec r3-router ip link set r3c-r up
sudo ip netns exec r3-server ip link set r3s up
sudo ip netns exec r3-router ip link set r3s-r up
sudo ip netns exec r3-client ip route add default via 10.10.30.1
sudo ip netns exec r3-server ip route add default via 10.20.30.1
sudo ip netns exec r3-router sysctl -w net.ipv4.ip_forward=1
```

## Execution Steps

### Step 1: Validate local and routed path selection

**Exact commands**

```bash
sudo ip netns exec r3-client ip route show
sudo ip netns exec r3-client ip route get 10.20.30.10
sudo ip netns exec r3-server ip route get 10.10.30.10
```

**Expected terminal output**

Expected output snippets:
- Client default route `via 10.10.30.1`
- Route lookup to server uses gateway `10.10.30.1`
- Server route lookup back to client uses `10.20.30.1`

**What is happening internally (network stack perspective)**

The client and server forward off-subnet packets to the router namespace, which must have IP forwarding enabled to pass traffic between interfaces.

### Step 2: Test end-to-end reachability and inspect hop behavior

**Exact commands**

```bash
sudo ip netns exec r3-client ping -c 2 10.20.30.10
sudo ip netns exec r3-client traceroute -n -m 3 10.20.30.10 || true
```

**Expected terminal output**

Expected output snippets:
- Ping succeeds to `10.20.30.10`
- `traceroute` first hop shows `10.10.30.1`, second hop `10.20.30.10` (depending on tool availability/ICMP behavior)

**What is happening internally (network stack perspective)**

The router decrements TTL and forwards packets between subnets; traceroute infers this from TTL expiry responses at each hop.

### Step 3: Observe forwarded packets on the router namespace

**Exact commands**

```bash
sudo ip netns exec r3-router tcpdump -ni any -c 6 icmp &
TCPDUMP_PID=$!
sleep 1
sudo ip netns exec r3-client ping -c 2 10.20.30.10 >/dev/null
wait $TCPDUMP_PID || true
```

**Expected terminal output**

Expected output snippets:
- `tcpdump` shows ICMP echo requests entering one interface and replies returning on the other

**What is happening internally (network stack perspective)**

Capturing inside the router namespace proves packets are reaching the routing node and being forwarded, isolating issues from host-level assumptions.

## Intentional Misconfiguration Scenario (Required)

Intentional misconfiguration: disable IP forwarding in the router namespace.

```bash
sudo ip netns exec r3-router sysctl -w net.ipv4.ip_forward=0
sudo ip netns exec r3-client ping -c 2 10.20.30.10 || true
sudo ip netns exec r3-router sysctl -w net.ipv4.ip_forward=1
```

Expected outcome:

- Client-to-server ping fails while local subnet pings to the router interface still work.

## Real-World Operational Failure Simulation (Required)

Real-world simulation: default route deleted on the server after an interface reconfiguration, causing one-way reachability symptoms.

```bash
sudo ip netns exec r3-server ip route del default
sudo ip netns exec r3-client ping -c 2 10.20.30.10 || true
sudo ip netns exec r3-server ip route show
sudo ip netns exec r3-server ip route add default via 10.20.30.1
```

## Debugging Walkthrough (Required)

1. Verify client route to remote subnet (`ip route get`).
2. Check router `net.ipv4.ip_forward` state.
3. Validate server return route and default gateway.
4. Capture ICMP on router to prove one-way vs two-way failure.

## Permission / Safety Notes

- `sudo` is required for network namespace creation, `iptables`, and `tcpdump` in most environments.
- If connected remotely, avoid applying host firewall changes outside namespaces unless you have console recovery access.
- Privileged ports (for example `53`, `80`) may require root-owned processes depending on the command used.
