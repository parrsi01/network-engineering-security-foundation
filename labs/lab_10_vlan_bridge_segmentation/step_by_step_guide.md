# Lab 10: VLAN Subinterfaces and Linux Bridge Segmentation - Step-by-Step Guide

## Lab Path

- Working directory reference: `labs/lab_10_vlan_bridge_segmentation`
- Validation script: `labs/lab_10_vlan_bridge_segmentation/validation_script.sh`

## Prerequisites

- Ubuntu Server LTS terminal access
- `sudo` permissions
- Required tools/packages for this lab (see commands below)

## Setup Commands (Exact)

```bash
sudo ip netns add vlan10-a
sudo ip netns add vlan10-b
sudo ip link add tr10a type veth peer name tr10b
sudo ip link set tr10a netns vlan10-a
sudo ip link set tr10b netns vlan10-b
sudo ip netns exec vlan10-a ip link set lo up
sudo ip netns exec vlan10-b ip link set lo up
sudo ip netns exec vlan10-a ip link set tr10a up
sudo ip netns exec vlan10-b ip link set tr10b up
sudo ip netns exec vlan10-a ip link add link tr10a name tr10a.10 type vlan id 10
sudo ip netns exec vlan10-b ip link add link tr10b name tr10b.10 type vlan id 10
sudo ip netns exec vlan10-a ip link add link tr10a name tr10a.20 type vlan id 20
sudo ip netns exec vlan10-b ip link add link tr10b name tr10b.20 type vlan id 20
sudo ip netns exec vlan10-a ip addr add 10.10.10.1/24 dev tr10a.10
sudo ip netns exec vlan10-b ip addr add 10.10.10.2/24 dev tr10b.10
sudo ip netns exec vlan10-a ip addr add 10.10.20.1/24 dev tr10a.20
sudo ip netns exec vlan10-b ip addr add 10.10.20.2/24 dev tr10b.20
sudo ip netns exec vlan10-a ip link set tr10a.10 up
sudo ip netns exec vlan10-b ip link set tr10b.10 up
sudo ip netns exec vlan10-a ip link set tr10a.20 up
sudo ip netns exec vlan10-b ip link set tr10b.20 up
sudo ip link add br-l10 type bridge || true
sudo ip link set br-l10 up || true
```

## Execution Steps

### Step 1: Inspect VLAN subinterfaces and bridge state

**Exact commands**

```bash
sudo ip netns exec vlan10-a ip -d link show type vlan
sudo ip netns exec vlan10-b ip -d link show type vlan
ip link show br-l10
```

**Expected terminal output**

- VLAN links show `vlan id 10` and `vlan id 20`; `br-l10` is present and `UP`.

**What is happening internally (network stack perspective)**

Linux stores VLAN tagging behavior on subinterfaces (`tr10a.10`, `tr10a.20`) and applies/removes 802.1Q tags as frames enter/leave the parent trunk interface.

### Step 2: Validate per-VLAN reachability

**Exact commands**

```bash
sudo ip netns exec vlan10-a ping -c 2 10.10.10.2
sudo ip netns exec vlan10-a ping -c 2 10.10.20.2
```

**Expected terminal output**

- Both pings succeed because matching VLAN IDs and IP subnets exist on both sides of the trunk.

**What is happening internally (network stack perspective)**

Each VLAN subinterface is a separate Layer 3 domain from Linux perspective; the same parent trunk carries multiple tagged frame types.

### Step 3: Capture tagged traffic on the trunk interface

**Exact commands**

```bash
sudo ip netns exec vlan10-a tcpdump -eni tr10a -c 10 vlan &
TPD=$!
sleep 1
sudo ip netns exec vlan10-b ping -c 2 10.10.10.1 >/dev/null
wait $TPD || true
```

**Expected terminal output**

- Capture shows frames with `vlan 10` tags on the trunk parent interface.

**What is happening internally (network stack perspective)**

Capturing on the parent trunk interface reveals the actual tagged frames, which is useful when troubleshooting trunk mismatch vs L3 addressing issues.

## Intentional Misconfiguration Scenario (Required)

Set the VLAN ID on one side to `30` instead of `20` for the second subnet and test reachability.

```bash
sudo ip netns exec vlan10-b ip link del tr10b.20
sudo ip netns exec vlan10-b ip link add link tr10b name tr10b.20 type vlan id 30
sudo ip netns exec vlan10-b ip addr add 10.10.20.2/24 dev tr10b.20
sudo ip netns exec vlan10-b ip link set tr10b.20 up
sudo ip netns exec vlan10-a ping -c 2 10.10.20.2 || true
```

Expected outcome:

- Ping to `10.10.20.2` fails because VLAN tags no longer match even though IP addressing appears correct.

## Real-World Operational Failure Simulation (Required)

A hypervisor trunk change leaves one VLAN tag misconfigured, causing only one application segment to fail while another VLAN continues working.

```bash
sudo ip netns exec vlan10-a ping -c 2 10.10.10.2
sudo ip netns exec vlan10-a ping -c 2 10.10.20.2 || true
sudo ip netns exec vlan10-a tcpdump -eni tr10a -c 20 vlan
```

## Debugging Walkthrough (Required)

1. Compare VLAN IDs with `ip -d link show type vlan` on both sides of the trunk.
2. Capture on the parent trunk interface to confirm actual VLAN tags on the wire.
3. Correct the VLAN ID mismatch and retest per-VLAN ping.

## Permission / Safety Notes

- `sudo` is required for namespaces, packet capture, and firewall changes.
- Stop test services after the lab to avoid unexpected local port conflicts.
- If running remotely, do not apply host firewall changes outside namespaces without recovery access.
