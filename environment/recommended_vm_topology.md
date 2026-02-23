# Recommended VM Topology

## Objective

Define a reproducible topology for running the labs on one Ubuntu VM while still practicing multi-host network troubleshooting patterns.

## Option A (Recommended): Single VM + Linux Network Namespaces

Use one Ubuntu VM and create namespaces to simulate:

- `client`
- `router`
- `server`
- `dns` (optional for DNS lab isolation)

Advantages:

- Low resource usage
- Fast reset
- No extra hypervisor networking complexity
- Works well in VS Code terminal and Codex CLI environment

## Option B: Two VMs + One Router Namespace

- VM1: client/tools
- VM2: server/services
- Namespace or host acts as router/firewall/NAT

Use when you want more realistic packet capture separation.

## Example Namespace Layout

- `client`: `10.10.10.10/24`
- `router` iface A: `10.10.10.1/24`
- `router` iface B: `10.20.20.1/24`
- `server`: `10.20.20.10/24`

## Verification Commands

```bash
ip netns list
ip link show type veth
ip netns exec client ip route
ip netns exec server ip route
```

Expected output:

- Namespaces created and listed
- `veth` pairs present and linked
- Client/server default route points to router namespace IP

## Troubleshooting Section

- If namespace command says permission denied, run with `sudo`
- If pings fail, verify each namespace interface is `UP`
- If forwarding fails, enable router namespace IP forwarding and inspect firewall rules
