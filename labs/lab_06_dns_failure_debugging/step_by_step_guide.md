# Lab 06: DNS Failure Debugging Workflow - Step-by-Step Guide

## Lab Path

- Working directory reference: `labs/lab_06_dns_failure_debugging`
- Validation script: `labs/lab_06_dns_failure_debugging/validation_script.sh`

## Prerequisites

- Ubuntu Server LTS terminal access
- `sudo` permissions for namespaces/firewall/capture tasks
- Recommended packages installed (see `README.md` and `environment/ubuntu_lab_setup.md`)

## Setup Commands (Exact)

```bash
sudo apt install -y dnsmasq >/dev/null
sudo ip netns add dns-client
sudo ip netns add dns-server
sudo ip link add br-l06 type bridge
sudo ip link set br-l06 up
sudo ip link add dnsc type veth peer name dnsc-ns
sudo ip link add dnss type veth peer name dnss-ns
sudo ip link set dnsc master br-l06
sudo ip link set dnss master br-l06
sudo ip link set dnsc up
sudo ip link set dnss up
sudo ip link set dnsc-ns netns dns-client
sudo ip link set dnss-ns netns dns-server
sudo ip netns exec dns-client ip link set lo up
sudo ip netns exec dns-server ip link set lo up
sudo ip netns exec dns-client ip addr add 10.60.6.10/24 dev dnsc-ns
sudo ip netns exec dns-server ip addr add 10.60.6.53/24 dev dnss-ns
sudo ip netns exec dns-client ip link set dnsc-ns up
sudo ip netns exec dns-server ip link set dnss-ns up
sudo mkdir -p /etc/netns/dns-client
echo 'nameserver 10.60.6.53' | sudo tee /etc/netns/dns-client/resolv.conf >/dev/null
cat > /tmp/dnsmasq-l06.conf <<'CFG'
no-daemon
no-resolv
interface=dnss-ns
bind-interfaces
listen-address=10.60.6.53
address=/lab6.test/10.60.6.100
CFG
sudo ip netns exec dns-server dnsmasq --conf-file=/tmp/dnsmasq-l06.conf >/tmp/dnsmasq-l06.log 2>&1 &
sleep 1
```

## Execution Steps

### Step 1: Validate DNS resolution via default namespace resolver path

**Exact commands**

```bash
sudo ip netns exec dns-client getent hosts lab6.test
sudo ip netns exec dns-client dig +short lab6.test
```

**Expected terminal output**

Expected output snippets:
- `10.60.6.100 lab6.test` from `getent hosts`
- `10.60.6.100` from `dig +short`

**What is happening internally (network stack perspective)**

The client namespace uses `/etc/netns/dns-client/resolv.conf`, so DNS queries are sent over UDP/53 to the lab DNS namespace instead of the host resolver.

### Step 2: Capture DNS queries and responses

**Exact commands**

```bash
sudo timeout 6 tcpdump -ni br-l06 port 53 -c 10 &
sleep 1
sudo ip netns exec dns-client dig +short lab6.test >/dev/null
wait || true
```

**Expected terminal output**

Expected output snippets:
- UDP/53 query from `10.60.6.10` to `10.60.6.53`
- Response containing `A 10.60.6.100`

**What is happening internally (network stack perspective)**

Packet capture proves whether the query leaves the client namespace and whether a valid response returns, separating transport issues from resolver behavior.

### Step 3: Compare direct and default resolver queries during debugging

**Exact commands**

```bash
sudo ip netns exec dns-client dig @10.60.6.53 +short lab6.test
sudo ip netns exec dns-client dig +short lab6.test
```

**Expected terminal output**

Expected output snippets:
- Both queries return `10.60.6.100` when resolver path is healthy

**What is happening internally (network stack perspective)**

Direct server queries bypass resolver configuration ambiguity; differences between direct and default queries usually indicate local resolver config issues.

## Intentional Misconfiguration Scenario (Required)

Intentional misconfiguration: set wrong nameserver IP in `/etc/netns/dns-client/resolv.conf`.

```bash
echo 'nameserver 10.60.6.99' | sudo tee /etc/netns/dns-client/resolv.conf >/dev/null
sudo ip netns exec dns-client dig +short lab6.test || true
sudo ip netns exec dns-client dig @10.60.6.53 +short lab6.test
echo 'nameserver 10.60.6.53' | sudo tee /etc/netns/dns-client/resolv.conf >/dev/null
```

Expected outcome:

- Default `dig` fails/timeouts; direct query to `10.60.6.53` succeeds, isolating resolver configuration as the problem.

## Real-World Operational Failure Simulation (Required)

Real-world simulation: firewall blocks UDP/53 but TCP/53 remains open, causing intermittent name resolution depending on query size and fallback behavior.

```bash
sudo ip netns exec dns-server iptables -I INPUT 1 -p udp --dport 53 -j DROP
sudo ip netns exec dns-client dig +time=1 +tries=1 +short lab6.test || true
sudo ip netns exec dns-server iptables -L INPUT -n -v --line-numbers
sudo ip netns exec dns-server iptables -D INPUT 1
```

## Debugging Walkthrough (Required)

1. Check resolver config file in `/etc/netns/dns-client/resolv.conf`.
2. Compare `dig +short` vs `dig @10.60.6.53 +short` results.
3. Capture `port 53` traffic to confirm queries/replies.
4. Inspect DNS namespace firewall rules if transport is blocked.

## Permission / Safety Notes

- `sudo` is required for network namespace creation, `iptables`, and `tcpdump` in most environments.
- If connected remotely, avoid applying host firewall changes outside namespaces unless you have console recovery access.
- Privileged ports (for example `53`, `80`) may require root-owned processes depending on the command used.
