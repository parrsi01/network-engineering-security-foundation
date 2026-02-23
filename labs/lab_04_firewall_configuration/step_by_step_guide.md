# Lab 04: Firewall Configuration with iptables/UFW on a Lab Router - Step-by-Step Guide

## Lab Path

- Working directory reference: `labs/lab_04_firewall_configuration`
- Validation script: `labs/lab_04_firewall_configuration/validation_script.sh`

## Prerequisites

- Ubuntu Server LTS terminal access
- `sudo` permissions for namespaces/firewall/capture tasks
- Recommended packages installed (see `README.md` and `environment/ubuntu_lab_setup.md`)

## Setup Commands (Exact)

```bash
# Build topology (same structure as lab_03, using unique names)
sudo ip netns add fw-client
sudo ip netns add fw-router
sudo ip netns add fw-server
sudo ip link add fwc type veth peer name fwc-r
sudo ip link add fws type veth peer name fws-r
sudo ip link set fwc netns fw-client
sudo ip link set fwc-r netns fw-router
sudo ip link set fws netns fw-server
sudo ip link set fws-r netns fw-router
sudo ip netns exec fw-client ip link set lo up
sudo ip netns exec fw-router ip link set lo up
sudo ip netns exec fw-server ip link set lo up
sudo ip netns exec fw-client ip addr add 10.10.40.10/24 dev fwc
sudo ip netns exec fw-router ip addr add 10.10.40.1/24 dev fwc-r
sudo ip netns exec fw-server ip addr add 10.20.40.10/24 dev fws
sudo ip netns exec fw-router ip addr add 10.20.40.1/24 dev fws-r
sudo ip netns exec fw-client ip link set fwc up
sudo ip netns exec fw-router ip link set fwc-r up
sudo ip netns exec fw-server ip link set fws up
sudo ip netns exec fw-router ip link set fws-r up
sudo ip netns exec fw-client ip route add default via 10.10.40.1
sudo ip netns exec fw-server ip route add default via 10.20.40.1
sudo ip netns exec fw-router sysctl -w net.ipv4.ip_forward=1
sudo ip netns exec fw-server python3 -m http.server 8080 >/tmp/fw-http.log 2>&1 &
```

## Execution Steps

### Step 1: Establish baseline connectivity before firewall enforcement

**Exact commands**

```bash
sudo ip netns exec fw-client ping -c 2 10.20.40.10
sudo ip netns exec fw-client curl -sI --max-time 3 http://10.20.40.10:8080 | head -5
```

**Expected terminal output**

Expected output snippets:
- Ping to `10.20.40.10` succeeds
- HTTP returns `200 OK`

**What is happening internally (network stack perspective)**

This proves the routed path and server listener work before adding filter policy, making later failures attributable to firewall changes.

### Step 2: Apply stateful iptables policy on the router namespace

**Exact commands**

```bash
sudo ip netns exec fw-router iptables -F
sudo ip netns exec fw-router iptables -P FORWARD DROP
sudo ip netns exec fw-router iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
sudo ip netns exec fw-router iptables -A FORWARD -s 10.10.40.10/32 -d 10.20.40.10/32 -p tcp --dport 8080 -j ACCEPT
sudo ip netns exec fw-router iptables -A FORWARD -s 10.10.40.10/32 -d 10.20.40.10/32 -p icmp -j ACCEPT
sudo ip netns exec fw-router iptables -L FORWARD -n -v --line-numbers
```

**Expected terminal output**

Expected output snippets:
- `Chain FORWARD (policy DROP)`
- `ESTABLISHED,RELATED` ACCEPT rule present near top
- Explicit `tcp dpt:8080` and `icmp` allow rules

**What is happening internally (network stack perspective)**

Packets traverse the filter `FORWARD` chain after routing decision; conntrack enables return traffic without symmetric explicit rules for every port.

### Step 3: Validate allowed and denied traffic paths

**Exact commands**

```bash
sudo ip netns exec fw-client ping -c 2 10.20.40.10
sudo ip netns exec fw-client curl -sI --max-time 3 http://10.20.40.10:8080 | head -5
sudo ip netns exec fw-client nc -vz -w 2 10.20.40.10 22 || true
sudo ip netns exec fw-router iptables -L FORWARD -n -v
```

**Expected terminal output**

Expected output snippets:
- Ping and HTTP succeed
- Port 22 probe fails (unless a service exists and rule was added)
- Rule counters increment on matching ACCEPT entries

**What is happening internally (network stack perspective)**

Counters confirm which rules handled the traffic; this is the fastest way to prove policy intent vs actual packet path.

## Intentional Misconfiguration Scenario (Required)

Intentional misconfiguration: place a blanket drop rule before the allow rules.

```bash
sudo ip netns exec fw-router iptables -I FORWARD 1 -j DROP
sudo ip netns exec fw-client curl -sI --max-time 3 http://10.20.40.10:8080 || true
sudo ip netns exec fw-router iptables -L FORWARD -n -v --line-numbers
sudo ip netns exec fw-router iptables -D FORWARD 1
```

Expected outcome:

- HTTP fails even though allow rules exist; line-numbered output shows traffic matches the earlier DROP rule first.

## Real-World Operational Failure Simulation (Required)

Real-world simulation: a change window introduces a default `DROP` policy but forgets the `ESTABLISHED,RELATED` rule, causing broken return traffic and intermittent symptoms.

```bash
sudo ip netns exec fw-router iptables -D FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT || true
sudo ip netns exec fw-client curl -sI --max-time 3 http://10.20.40.10:8080 || true
sudo ip netns exec fw-router iptables -L FORWARD -n -v --line-numbers
```

## Debugging Walkthrough (Required)

1. Confirm service still listens on server namespace (`ss -tulpn`).
2. Inspect FORWARD chain with counters and line numbers to identify drop location.
3. Restore `ESTABLISHED,RELATED` rule near the top, then retest HTTP.

## Permission / Safety Notes

- `sudo` is required for network namespace creation, `iptables`, and `tcpdump` in most environments.
- If connected remotely, avoid applying host firewall changes outside namespaces unless you have console recovery access.
- Privileged ports (for example `53`, `80`) may require root-owned processes depending on the command used.
