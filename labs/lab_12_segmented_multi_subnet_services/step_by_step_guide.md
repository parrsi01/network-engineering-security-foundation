# Lab 12: Segmented Multi-Subnet Services and Policy Enforcement - Step-by-Step Guide

## Lab Path

- Working directory reference: `labs/lab_12_segmented_multi_subnet_services`
- Validation script: `labs/lab_12_segmented_multi_subnet_services/validation_script.sh`

## Prerequisites

- Ubuntu Server LTS terminal access
- `sudo` permissions
- Required tools/packages for this lab (see commands below)

## Setup Commands (Exact)

```bash
sudo ip netns add s12-client
sudo ip netns add s12-router
sudo ip netns add s12-app
sudo ip netns add s12-db
sudo ip link add s12c type veth peer name s12c-r
sudo ip link add s12a type veth peer name s12a-r
sudo ip link add s12d type veth peer name s12d-r
sudo ip link set s12c netns s12-client
sudo ip link set s12c-r netns s12-router
sudo ip link set s12a netns s12-app
sudo ip link set s12a-r netns s12-router
sudo ip link set s12d netns s12-db
sudo ip link set s12d-r netns s12-router
for ns in s12-client s12-router s12-app s12-db; do sudo ip netns exec $ns ip link set lo up; done
sudo ip netns exec s12-client ip addr add 10.12.10.10/24 dev s12c
sudo ip netns exec s12-router ip addr add 10.12.10.1/24 dev s12c-r
sudo ip netns exec s12-app ip addr add 10.12.20.10/24 dev s12a
sudo ip netns exec s12-router ip addr add 10.12.20.1/24 dev s12a-r
sudo ip netns exec s12-db ip addr add 10.12.30.10/24 dev s12d
sudo ip netns exec s12-router ip addr add 10.12.30.1/24 dev s12d-r
sudo ip netns exec s12-client ip link set s12c up
sudo ip netns exec s12-router ip link set s12c-r up
sudo ip netns exec s12-app ip link set s12a up
sudo ip netns exec s12-router ip link set s12a-r up
sudo ip netns exec s12-db ip link set s12d up
sudo ip netns exec s12-router ip link set s12d-r up
sudo ip netns exec s12-client ip route add default via 10.12.10.1
sudo ip netns exec s12-app ip route add default via 10.12.20.1
sudo ip netns exec s12-db ip route add default via 10.12.30.1
sudo ip netns exec s12-router sysctl -w net.ipv4.ip_forward=1
sudo ip netns exec s12-app python3 -m http.server 8080 >/tmp/s12-app-http.log 2>&1 &
sudo ip netns exec s12-db nc -lk -p 5432 >/tmp/s12-db-nc.log 2>&1 &
sudo ip netns exec s12-router iptables -F
sudo ip netns exec s12-router iptables -P FORWARD DROP
sudo ip netns exec s12-router iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
sudo ip netns exec s12-router iptables -A FORWARD -s 10.12.10.0/24 -d 10.12.20.10/32 -p tcp --dport 8080 -j ACCEPT
sudo ip netns exec s12-router iptables -A FORWARD -s 10.12.20.10/32 -d 10.12.30.10/32 -p tcp --dport 5432 -j ACCEPT
```

## Execution Steps

### Step 1: Validate intended allowed paths

**Exact commands**

```bash
sudo ip netns exec s12-client curl -sI --max-time 3 http://10.12.20.10:8080 | head -5
sudo ip netns exec s12-app nc -vz -w 2 10.12.30.10 5432
```

**Expected terminal output**

- Client reaches app HTTP; app reaches DB TCP/5432.

**What is happening internally (network stack perspective)**

Router namespace routes inter-subnet traffic, then `FORWARD` chain enforces policy. Conntrack allows return packets without duplicate reverse rules.

### Step 2: Validate blocked path (client -> DB)

**Exact commands**

```bash
sudo ip netns exec s12-client nc -vz -w 2 10.12.30.10 5432 || true
sudo ip netns exec s12-router iptables -L FORWARD -n -v --line-numbers
```

**Expected terminal output**

- Client -> DB connection fails; `FORWARD` chain counters show allowed paths and default policy handling.

**What is happening internally (network stack perspective)**

Segmentation is proven by explicit denial of non-approved flows while required app dependencies remain reachable.

### Step 3: Inspect packet path and listener state during troubleshooting

**Exact commands**

```bash
sudo ip netns exec s12-app ss -tulpn | grep 8080
sudo ip netns exec s12-db ss -tulpn | grep 5432
sudo ip netns exec s12-router tcpdump -ni any 'host 10.12.20.10 or host 10.12.30.10' -c 20
```

**Expected terminal output**

- App and DB listeners are present; router capture shows routed traffic for allowed flows.

**What is happening internally (network stack perspective)**

Combining socket inspection with router-side capture distinguishes policy failures from service/listener failures.

## Intentional Misconfiguration Scenario (Required)

Insert a broad allow rule for client -> DB before policy review (simulating accidental overexposure).

```bash
sudo ip netns exec s12-router iptables -I FORWARD 2 -s 10.12.10.0/24 -d 10.12.30.10/32 -p tcp --dport 5432 -j ACCEPT
sudo ip netns exec s12-client nc -vz -w 2 10.12.30.10 5432 || true
sudo ip netns exec s12-router iptables -L FORWARD -n -v --line-numbers
```

Expected outcome:

- Client unexpectedly reaches DB, demonstrating policy drift / overexposure caused by a single incorrect rule.

## Real-World Operational Failure Simulation (Required)

A segmentation change removes the `ESTABLISHED,RELATED` rule, breaking app responses even though allow rules remain present.

```bash
sudo ip netns exec s12-router iptables -D FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT || true
sudo ip netns exec s12-client curl -sI --max-time 3 http://10.12.20.10:8080 || true
sudo ip netns exec s12-router iptables -L FORWARD -n -v --line-numbers
```

## Debugging Walkthrough (Required)

1. Verify app and DB listeners before changing firewall rules.
2. Inspect `FORWARD` chain order and counters, especially `ESTABLISHED,RELATED` placement.
3. Re-test allowed and denied paths separately and document the final policy intent.

## Permission / Safety Notes

- `sudo` is required for namespaces, packet capture, and firewall changes.
- Stop test services after the lab to avoid unexpected local port conflicts.
- If running remotely, do not apply host firewall changes outside namespaces without recovery access.
