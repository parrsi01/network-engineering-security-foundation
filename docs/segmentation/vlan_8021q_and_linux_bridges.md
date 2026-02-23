# VLAN 802.1Q and Linux Bridges

## Objective

Map VLAN tagging concepts to Linux bridge and VLAN subinterface behavior so you can build segmented labs on Ubuntu and troubleshoot trunk/access mistakes.

## Core Concepts

- 802.1Q adds a VLAN tag to Ethernet frames on trunk links
- Access ports carry untagged traffic in a single VLAN
- Trunk ports carry multiple VLANs (tagged frames)
- Linux can model this with bridges (`ip link add type bridge`) and VLAN interfaces (`eth0.10`)

## Ubuntu CLI Examples

```bash
sudo ip link add br0 type bridge
sudo ip link set br0 up
sudo ip link add link eth0 name eth0.10 type vlan id 10
sudo ip link add link eth0 name eth0.20 type vlan id 20
ip -d link show type vlan
bridge vlan show
```

Expected output indicators:

- VLAN interfaces display `vlan id 10` / `vlan id 20`
- `bridge vlan show` lists VLAN membership per port when bridge VLAN filtering is used

## Internal Packet Perspective

On a trunk, tagged frames preserve VLAN identity across a single physical/logical link. Linux strips or applies the VLAN tag at the VLAN subinterface boundary, then passes the payload to the relevant L3 stack/bridge domain.

## Common Failure Modes

- Wrong VLAN ID on one side of a trunk
- Bridge port not attached to the correct bridge
- Interface `DOWN` after creation (common in namespaces)
- Expecting inter-VLAN routing when only L2 bridging is configured

## Troubleshooting Section

```bash
ip -d link show
bridge link show
bridge vlan show
ip addr show
sudo tcpdump -eni <iface> vlan
```

Use `tcpdump -e` to confirm whether VLAN tags are present on the wire and `bridge vlan show` to confirm membership intent vs actual configuration.
