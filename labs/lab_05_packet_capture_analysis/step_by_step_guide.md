# Lab 05: Packet Capture Analysis with tcpdump - Step-by-Step Guide

## Lab Path

- Working directory reference: `labs/lab_05_packet_capture_analysis`
- Validation script: `labs/lab_05_packet_capture_analysis/validation_script.sh`

## Prerequisites

- Ubuntu Server LTS terminal access
- `sudo` permissions for namespaces/firewall/capture tasks
- Recommended packages installed (see `README.md` and `environment/ubuntu_lab_setup.md`)

## Setup Commands (Exact)

```bash
sudo ip netns add cap-client
sudo ip netns add cap-server
sudo ip link add br-l05 type bridge
sudo ip link set br-l05 up
sudo ip link add capc type veth peer name capc-ns
sudo ip link add caps type veth peer name caps-ns
sudo ip link set capc master br-l05
sudo ip link set caps master br-l05
sudo ip link set capc up
sudo ip link set caps up
sudo ip link set capc-ns netns cap-client
sudo ip link set caps-ns netns cap-server
sudo ip netns exec cap-client ip link set lo up
sudo ip netns exec cap-server ip link set lo up
sudo ip netns exec cap-client ip addr add 10.50.5.10/24 dev capc-ns
sudo ip netns exec cap-server ip addr add 10.50.5.20/24 dev caps-ns
sudo ip netns exec cap-client ip link set capc-ns up
sudo ip netns exec cap-server ip link set caps-ns up
sudo ip netns exec cap-server python3 -m http.server 8080 >/tmp/cap-http.log 2>&1 &
mkdir -p labs/lab_05_packet_capture_analysis/captures
```

## Execution Steps

### Step 1: Capture ARP and ICMP while testing ping

**Exact commands**

```bash
sudo timeout 6 tcpdump -ni br-l05 -e '(arp or icmp)' -w labs/lab_05_packet_capture_analysis/captures/ping_trace.pcap &
sleep 1
sudo ip netns exec cap-client ping -c 2 10.50.5.20
wait || true
sudo tcpdump -nn -r labs/lab_05_packet_capture_analysis/captures/ping_trace.pcap | head -20
```

**Expected terminal output**

Expected output snippets:
- ARP request/reply for `10.50.5.20`
- ICMP echo request and echo reply packets

**What is happening internally (network stack perspective)**

ARP frames appear before ICMP on first contact because the client needs the server MAC address before sending the echo request.

### Step 2: Capture and read a TCP handshake + HTTP exchange

**Exact commands**

```bash
sudo timeout 6 tcpdump -ni br-l05 tcp port 8080 -w labs/lab_05_packet_capture_analysis/captures/http_trace.pcap &
sleep 1
sudo ip netns exec cap-client curl -s http://10.50.5.20:8080 >/dev/null
wait || true
sudo tcpdump -nn -r labs/lab_05_packet_capture_analysis/captures/http_trace.pcap | head -30
```

**Expected terminal output**

Expected output snippets:
- TCP `SYN`, `SYN,ACK`, `ACK`
- HTTP data packets / ACKs
- FIN/ACK or RST teardown depending on client behavior

**What is happening internally (network stack perspective)**

The TCP handshake proves transport reachability before application data; packet ordering clarifies whether failures occur before or after session establishment.

### Step 3: Use capture filters for focused evidence collection

**Exact commands**

```bash
sudo tcpdump -ni br-l05 'host 10.50.5.20 and port 8080' -c 10
```

**Expected terminal output**

Expected output snippets:
- Only packets involving the target host and TCP/8080 are displayed

**What is happening internally (network stack perspective)**

Capture filters reduce noise at capture time, which is useful in busy environments but should be chosen carefully to avoid missing related traffic.

## Intentional Misconfiguration Scenario (Required)

Intentional misconfiguration: capture on the wrong interface (`eth0`) instead of `br-l05`.

```bash
sudo timeout 4 tcpdump -ni eth0 icmp -c 5 || true
sudo ip netns exec cap-client ping -c 2 10.50.5.20
```

Expected outcome:

- Ping succeeds but capture shows no relevant packets because the wrong interface was selected.

## Real-World Operational Failure Simulation (Required)

Real-world simulation: HTTP service is stopped; packet capture reveals SYN retransmissions or RST rather than application data.

```bash
sudo pkill -f 'python3 -m http.server 8080' || true
sudo timeout 6 tcpdump -ni br-l05 tcp port 8080 -c 12 &
sleep 1
sudo ip netns exec cap-client curl -s --max-time 3 http://10.50.5.20:8080 >/dev/null || true
wait || true
```

## Debugging Walkthrough (Required)

1. Confirm you are capturing on the correct interface (`br-l05`).
2. Read the packet sequence: ARP/ICMP/TCP handshake/application data.
3. Differentiate no packets, SYN-only, RST, and full HTTP exchange patterns.

## Permission / Safety Notes

- `sudo` is required for network namespace creation, `iptables`, and `tcpdump` in most environments.
- If connected remotely, avoid applying host firewall changes outside namespaces unless you have console recovery access.
- Privileged ports (for example `53`, `80`) may require root-owned processes depending on the command used.
