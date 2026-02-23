# Lab Network Diagram (ASCII)

## Reference Diagram

```text
              +---------------------------+
              |      Ubuntu Host VM       |
              | (VS Code Terminal / CLI)  |
              +---------------------------+
                 |                 |
                 | Linux netns     | Local host tools
                 v                 v
      +----------------+    +----------------+
      | netns: client   |    | Host namespace |
      | 10.10.10.10/24  |    | tcpdump, dig,  |
      | gw 10.10.10.1   |    | iptables, ufw  |
      +--------+--------+    +--------+-------+
               | veth pair              |
               |                        |
      +--------v------------------------v-------+
      |         netns: router / firewall        |
      | ethA 10.10.10.1/24  ethB 10.20.20.1/24 |
      | NAT / firewall / forwarding labs        |
      +---------------------+-------------------+
                            | veth pair
                            |
                 +----------v-----------+
                 |    netns: server     |
                 | 10.20.20.10/24       |
                 | test HTTP/DNS svc    |
                 +----------------------+
```

## Operational Mapping

- Labs 01-03 focus on interface/address/route verification
- Labs 04 and 07 use the router namespace for firewall/NAT
- Lab 05 uses `tcpdump` in host or namespace interfaces
- Lab 06 introduces DNS failure simulation in `server` or host resolver path
- Lab 08 adds WireGuard conceptual config and local validation

## Troubleshooting Section

- If namespace names differ from the lab docs, adjust commands consistently
- If captures show no traffic, confirm you are sniffing the correct interface (`veth-*` vs `eth0`)
