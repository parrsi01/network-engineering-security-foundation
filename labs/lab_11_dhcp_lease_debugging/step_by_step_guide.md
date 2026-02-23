# Lab 11: DHCP Lease Debugging with dnsmasq and dhclient - Step-by-Step Guide

## Lab Path

- Working directory reference: `labs/lab_11_dhcp_lease_debugging`
- Validation script: `labs/lab_11_dhcp_lease_debugging/validation_script.sh`

## Prerequisites

- Ubuntu Server LTS terminal access
- `sudo` permissions
- Required tools/packages for this lab (see commands below)

## Setup Commands (Exact)

```bash
sudo apt install -y dnsmasq isc-dhcp-client >/dev/null
sudo ip netns add dhcp11-client
sudo ip netns add dhcp11-server
sudo ip link add br-l11 type bridge || true
sudo ip link set br-l11 up
sudo ip link add d11c type veth peer name d11c-ns
sudo ip link add d11s type veth peer name d11s-ns
sudo ip link set d11c master br-l11
sudo ip link set d11s master br-l11
sudo ip link set d11c up
sudo ip link set d11s up
sudo ip link set d11c-ns netns dhcp11-client
sudo ip link set d11s-ns netns dhcp11-server
sudo ip netns exec dhcp11-client ip link set lo up
sudo ip netns exec dhcp11-server ip link set lo up
sudo ip netns exec dhcp11-client ip link set d11c-ns up
sudo ip netns exec dhcp11-server ip link set d11s-ns up
sudo ip netns exec dhcp11-server ip addr add 10.11.0.1/24 dev d11s-ns
cat > /tmp/dnsmasq-l11.conf <<'CFG'
no-daemon
bind-interfaces
interface=d11s-ns
dhcp-range=10.11.0.100,10.11.0.120,255.255.255.0,1h
dhcp-option=3,10.11.0.1
dhcp-option=6,1.1.1.1
CFG
sudo ip netns exec dhcp11-server pkill -x dnsmasq || true
sudo ip netns exec dhcp11-server dnsmasq --conf-file=/tmp/dnsmasq-l11.conf >/tmp/dnsmasq-l11.log 2>&1 &
sleep 1
sudo ip netns exec dhcp11-client dhclient -r d11c-ns || true
sudo ip netns exec dhcp11-client dhclient -v d11c-ns
```

## Execution Steps

### Step 1: Verify lease acquisition and interface addressing

**Exact commands**

```bash
sudo ip netns exec dhcp11-client ip -o -4 addr show dev d11c-ns
sudo ip netns exec dhcp11-client ip route show
```

**Expected terminal output**

- Client interface gets an address in `10.11.0.100-120/24`, and a default route via `10.11.0.1` may be installed by DHCP.

**What is happening internally (network stack perspective)**

After DHCPACK, `dhclient` programs the interface IP, route, and resolver-related settings according to lease options.

### Step 2: Observe DORA packets with tcpdump

**Exact commands**

```bash
sudo timeout 8 tcpdump -ni br-l11 'udp port 67 or udp port 68' -c 20 &
TPID=$!
sleep 1
sudo ip netns exec dhcp11-client dhclient -r d11c-ns || true
sudo ip netns exec dhcp11-client dhclient -v d11c-ns
wait $TPID || true
```

**Expected terminal output**

- Capture shows DHCP Discover/Offer/Request/Ack UDP traffic between client and server.

**What is happening internally (network stack perspective)**

DHCP starts with broadcast traffic because the client lacks an IP, then transitions to configured Layer 3 once the lease is acknowledged.

### Step 3: Validate server listener and logs

**Exact commands**

```bash
sudo ip netns exec dhcp11-server ss -lunp | grep ':67'
sudo tail -n 20 /tmp/dnsmasq-l11.log
```

**Expected terminal output**

- `dnsmasq` is listening on UDP/67 in the server namespace; logs show lease assignment events.

**What is happening internally (network stack perspective)**

A healthy DHCP server must be bound to the correct interface/subnet and able to send broadcast/unicast replies back to clients.

## Intentional Misconfiguration Scenario (Required)

Change the DHCP range to the wrong subnet (`10.12.0.0/24`) and restart dnsmasq.

```bash
sed -i 's/10.11.0.100,10.11.0.120/10.12.0.100,10.12.0.120/' /tmp/dnsmasq-l11.conf
sudo ip netns exec dhcp11-server pkill -x dnsmasq || true
sudo ip netns exec dhcp11-server dnsmasq --conf-file=/tmp/dnsmasq-l11.conf >/tmp/dnsmasq-l11.log 2>&1 &
sleep 1
sudo ip netns exec dhcp11-client dhclient -r d11c-ns || true
sudo ip netns exec dhcp11-client dhclient -v -1 d11c-ns || true
```

Expected outcome:

- Lease request fails because the server range does not match the serving interface subnet.

## Real-World Operational Failure Simulation (Required)

A DHCP change introduces a wrong scope or local firewall drop on UDP/67, causing endpoints to lose lease renewal capability.

```bash
sudo ip netns exec dhcp11-server iptables -I INPUT 1 -p udp --dport 67 -j DROP
sudo ip netns exec dhcp11-client dhclient -r d11c-ns || true
sudo ip netns exec dhcp11-client dhclient -v -1 d11c-ns || true
sudo ip netns exec dhcp11-server iptables -L INPUT -n -v --line-numbers
sudo ip netns exec dhcp11-server iptables -D INPUT 1
```

## Debugging Walkthrough (Required)

1. Check `dnsmasq` process and UDP/67 listener in the DHCP server namespace.
2. Capture UDP 67/68 traffic to confirm Discover leaves and Offer/Ack returns.
3. Validate DHCP range/subnet alignment and remove any firewall drops on UDP/67/68.

## Permission / Safety Notes

- `sudo` is required for namespaces, packet capture, and firewall changes.
- Stop test services after the lab to avoid unexpected local port conflicts.
- If running remotely, do not apply host firewall changes outside namespaces without recovery access.
