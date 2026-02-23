# 02 - Linux Network CLI

## High-Value Commands

### `ip`
Use for interfaces, addresses, routes, neighbors.

```bash
ip -br addr
ip route get <target>
ip neigh show
```

### `ss`
Use for socket/listener state.

```bash
ss -tulpn
ss -tan state syn-sent
```

### `tcpdump`
Use for packet evidence.

```bash
sudo tcpdump -ni <iface> host <target>
```

### `dig` and `getent`
Use to separate resolver path issues from DNS server reachability issues.

```bash
getent hosts <name>
dig +short <name>
dig @<dns_server> +short <name>
```
