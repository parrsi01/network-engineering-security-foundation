# Lab 07: NAT and Port Forwarding on a Linux Router Namespace - Step-by-Step Guide

## Lab Path

- Working directory reference: `labs/lab_07_nat_port_forwarding`
- Validation script: `labs/lab_07_nat_port_forwarding/validation_script.sh`

## Prerequisites

- Ubuntu Server LTS terminal access
- `sudo` permissions for namespaces/firewall/capture tasks
- Recommended packages installed (see `README.md` and `environment/ubuntu_lab_setup.md`)

## Setup Commands (Exact)

```bash
sudo ip netns add nat-client
sudo ip netns add nat-router
sudo ip netns add nat-server
sudo ip link add nc type veth peer name nc-r
sudo ip link add ns type veth peer name ns-r
sudo ip link set nc netns nat-client
sudo ip link set nc-r netns nat-router
sudo ip link set ns netns nat-server
sudo ip link set ns-r netns nat-router
sudo ip netns exec nat-client ip link set lo up
sudo ip netns exec nat-router ip link set lo up
sudo ip netns exec nat-server ip link set lo up
sudo ip netns exec nat-client ip addr add 10.10.70.10/24 dev nc
sudo ip netns exec nat-router ip addr add 10.10.70.1/24 dev nc-r
sudo ip netns exec nat-server ip addr add 10.20.70.10/24 dev ns
sudo ip netns exec nat-router ip addr add 10.20.70.1/24 dev ns-r
sudo ip netns exec nat-client ip link set nc up
sudo ip netns exec nat-router ip link set nc-r up
sudo ip netns exec nat-server ip link set ns up
sudo ip netns exec nat-router ip link set ns-r up
sudo ip netns exec nat-client ip route add default via 10.10.70.1
sudo ip netns exec nat-server ip route add default via 10.20.70.1
sudo ip netns exec nat-router sysctl -w net.ipv4.ip_forward=1
sudo ip netns exec nat-server python3 -m http.server 80 >/tmp/nat-http.log 2>&1 &
sudo ip netns exec nat-router iptables -F
sudo ip netns exec nat-router iptables -t nat -F
```

## Execution Steps

### Step 1: Configure DNAT and required FORWARD rules

**Exact commands**

```bash
sudo ip netns exec nat-router iptables -P FORWARD DROP
sudo ip netns exec nat-router iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
sudo ip netns exec nat-router iptables -A FORWARD -s 10.10.70.10/32 -d 10.20.70.10/32 -p tcp --dport 80 -j ACCEPT
sudo ip netns exec nat-router iptables -t nat -A PREROUTING -i nc-r -p tcp --dport 8080 -j DNAT --to-destination 10.20.70.10:80
sudo ip netns exec nat-router iptables -t nat -A POSTROUTING -s 10.10.70.0/24 -o ns-r -j MASQUERADE
sudo ip netns exec nat-router iptables -t nat -S
```

**Expected terminal output**

Expected output snippets:
- DNAT `PREROUTING` rule for `--dport 8080`
- `POSTROUTING ... MASQUERADE` rule for client subnet

**What is happening internally (network stack perspective)**

DNAT rewrites the destination before routing; the packet is then routed to the server subnet and must pass the FORWARD chain. Reply traffic uses conntrack/NAT state.

### Step 2: Validate port forward from client to router IP:8080

**Exact commands**

```bash
sudo ip netns exec nat-client curl -sI --max-time 3 http://10.10.70.1:8080 | head -5
sudo ip netns exec nat-router iptables -L FORWARD -n -v
sudo ip netns exec nat-router iptables -t nat -L PREROUTING -n -v
```

**Expected terminal output**

Expected output snippets:
- HTTP response `200 OK`
- NAT and FORWARD counters increment

**What is happening internally (network stack perspective)**

The client targets the router IP, but DNAT rewrites the packet to the server; counters prove which tables handled the flow.

### Step 3: Capture translated traffic on router interfaces

**Exact commands**

```bash
sudo ip netns exec nat-router tcpdump -ni any 'tcp port 8080 or tcp port 80' -c 20 &
TCP_PID=$!
sleep 1
sudo ip netns exec nat-client curl -s http://10.10.70.1:8080 >/dev/null
wait $TCP_PID || true
```

**Expected terminal output**

Expected output snippets:
- Packets arrive on `nc-r` with destination port 8080
- Forwarded packets toward `ns-r` use destination port 80

**What is happening internally (network stack perspective)**

Capturing in the router namespace shows packet transformation across hooks and interfaces, which is critical for DNAT troubleshooting.

## Intentional Misconfiguration Scenario (Required)

Intentional misconfiguration: omit the `FORWARD` allow rule while keeping DNAT configured.

```bash
sudo ip netns exec nat-router iptables -F FORWARD
sudo ip netns exec nat-router iptables -P FORWARD DROP
sudo ip netns exec nat-client curl -sI --max-time 3 http://10.10.70.1:8080 || true
sudo ip netns exec nat-router iptables -L FORWARD -n -v --line-numbers
```

Expected outcome:

- Connection fails despite a correct NAT rule; FORWARD chain drops the translated packets.

## Real-World Operational Failure Simulation (Required)

Real-world simulation: port forward points to the wrong internal IP after a server IP change.

```bash
sudo ip netns exec nat-router iptables -t nat -R PREROUTING 1 -i nc-r -p tcp --dport 8080 -j DNAT --to-destination 10.20.70.99:80
sudo ip netns exec nat-client curl -sI --max-time 3 http://10.10.70.1:8080 || true
sudo ip netns exec nat-router iptables -t nat -L PREROUTING -n -v --line-numbers
```

## Debugging Walkthrough (Required)

1. Validate `net.ipv4.ip_forward=1` in `nat-router` namespace.
2. Check NAT table (`iptables -t nat -S`) and FORWARD chain together; NAT alone is insufficient.
3. Capture traffic on both router interfaces to confirm translation and forwarding path.
4. Verify server listener on `10.20.70.10:80`.

## Permission / Safety Notes

- `sudo` is required for network namespace creation, `iptables`, and `tcpdump` in most environments.
- If connected remotely, avoid applying host firewall changes outside namespaces unless you have console recovery access.
- Privileged ports (for example `53`, `80`) may require root-owned processes depending on the command used.
