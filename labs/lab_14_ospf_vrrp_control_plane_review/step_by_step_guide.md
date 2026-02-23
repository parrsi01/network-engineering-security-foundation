# Lab 14: OSPF (FRR) and VRRP (Keepalived) Control-Plane Review + VIP Failover Simulation - Step-by-Step Guide

## Lab Path

- Working directory reference: `labs/lab_14_ospf_vrrp_control_plane_review`
- Validation script: `labs/lab_14_ospf_vrrp_control_plane_review/validation_script.sh`

## Prerequisites

- Ubuntu Server LTS terminal access
- `sudo` permissions
- Required tools/packages for this lab (see commands below)

## Setup Commands (Exact)

```bash
mkdir -p /tmp/lab14-adv
cp configs/sample_frr_ospfd.conf /tmp/lab14-adv/ospfd.conf
cp configs/sample_keepalived.conf /tmp/lab14-adv/keepalived.conf
sudo ip netns add vrrp14-a
sudo ip netns add vrrp14-b
sudo ip netns add vrrp14-client
sudo ip link add br-l14 type bridge || true
sudo ip link set br-l14 up
sudo ip link add v14a type veth peer name v14a-ns
sudo ip link add v14b type veth peer name v14b-ns
sudo ip link add v14c type veth peer name v14c-ns
sudo ip link set v14a master br-l14
sudo ip link set v14b master br-l14
sudo ip link set v14c master br-l14
sudo ip link set v14a up
sudo ip link set v14b up
sudo ip link set v14c up
sudo ip link set v14a-ns netns vrrp14-a
sudo ip link set v14b-ns netns vrrp14-b
sudo ip link set v14c-ns netns vrrp14-client
for ns in vrrp14-a vrrp14-b vrrp14-client; do sudo ip netns exec $ns ip link set lo up; done
sudo ip netns exec vrrp14-a ip addr add 10.14.0.11/24 dev v14a-ns
sudo ip netns exec vrrp14-b ip addr add 10.14.0.12/24 dev v14b-ns
sudo ip netns exec vrrp14-client ip addr add 10.14.0.50/24 dev v14c-ns
sudo ip netns exec vrrp14-a ip link set v14a-ns up
sudo ip netns exec vrrp14-b ip link set v14b-ns up
sudo ip netns exec vrrp14-client ip link set v14c-ns up
sudo ip netns exec vrrp14-a ip addr add 10.14.0.254/24 dev v14a-ns label v14a-ns:vip
```

## Execution Steps

### Step 1: Review OSPF and Keepalived config syntax patterns

**Exact commands**

```bash
grep -E '^(router ospf| network | interface )' /tmp/lab14-adv/ospfd.conf
grep -E '^(vrrp_instance| interface | virtual_router_id | priority | virtual_ipaddress)' /tmp/lab14-adv/keepalived.conf
sudo vtysh -c 'show ip ospf neighbor' 2>/dev/null || true
```

**Expected terminal output**

- Config files contain OSPF network statements and VRRP/Keepalived instance parameters; optional `vtysh` output appears if FRR is installed.

**What is happening internally (network stack perspective)**

OSPF and VRRP are control-plane protocols; validating config intent and control-plane visibility is the first step before data-plane debugging.

### Step 2: Validate VIP reachability from client namespace

**Exact commands**

```bash
sudo ip netns exec vrrp14-client ping -c 2 10.14.0.254
sudo ip netns exec vrrp14-client ip neigh show
```

**Expected terminal output**

- Client reaches the VIP and learns a neighbor MAC corresponding to the active node holding the VIP.

**What is happening internally (network stack perspective)**

The VIP simulates the VRRP shared gateway/service IP. Neighbor cache entries reflect whichever node currently owns the VIP.

### Step 3: Simulate VRRP failover by moving the VIP to backup node

**Exact commands**

```bash
sudo ip netns exec vrrp14-a ip addr del 10.14.0.254/24 dev v14a-ns
sudo ip netns exec vrrp14-b ip addr add 10.14.0.254/24 dev v14b-ns label v14b-ns:vip
sudo ip netns exec vrrp14-b arping -c 2 -A -I v14b-ns 10.14.0.254 2>/dev/null || true
sudo ip netns exec vrrp14-client ping -c 2 10.14.0.254
sudo ip netns exec vrrp14-client ip neigh show | grep 10.14.0.254 || true
```

**Expected terminal output**

- VIP remains reachable after moving to the backup node, demonstrating failover continuity (manual simulation of VRRP behavior).

**What is happening internally (network stack perspective)**

VRRP failover relies on control-plane advertisements and gratuitous ARP to update downstream neighbor tables. Manual VIP move simulates the critical L2/L3 effect.

## Intentional Misconfiguration Scenario (Required)

Set a mismatched virtual IP in the Keepalived config review file and compare with the implemented VIP.

```bash
sed -i 's/10.14.0.254/10.14.0.253/' /tmp/lab14-adv/keepalived.conf
grep -n 'virtual_ipaddress' -A2 /tmp/lab14-adv/keepalived.conf
sudo ip netns exec vrrp14-client ping -c 2 10.14.0.254 || true
```

Expected outcome:

- Config intent no longer matches deployed VIP, simulating drift that causes confusion during failover validation.

## Real-World Operational Failure Simulation (Required)

Control-plane issue simulation: OSPF neighbor fails to form (protocol 89 blocked) or VRRP advertisements stop, leading to route/VIP instability.

```bash
echo 'OSPF check sequence (optional if FRR installed): vtysh show ip ospf neighbor; tcpdump proto 89'
echo 'VRRP check sequence: keepalived status, tcpdump vrrp, VIP ownership, client ARP table'
sudo ip netns exec vrrp14-a ip addr show dev v14a-ns
sudo ip netns exec vrrp14-b ip addr show dev v14b-ns
```

## Debugging Walkthrough (Required)

1. Validate config intent first (OSPF network statements, VRRP VIP/interface/priority).
2. Check control-plane visibility (`proto 89`, `vrrp`) before changing data-plane rules.
3. Confirm current VIP owner and client ARP cache after simulated failover.

## Permission / Safety Notes

- `sudo` is required for namespaces, packet capture, and firewall changes.
- Stop test services after the lab to avoid unexpected local port conflicts.
- If running remotely, do not apply host firewall changes outside namespaces without recovery access.
