# Lab 07: NAT and Port Forwarding on a Linux Router Namespace - Full Solution

## Final Working Configuration

The following commands restore or apply the validated end state for this lab.

```bash
# Final working NAT and forward policy
sudo ip netns exec nat-router iptables -F FORWARD
sudo ip netns exec nat-router iptables -t nat -F
sudo ip netns exec nat-router iptables -P FORWARD DROP
sudo ip netns exec nat-router iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
sudo ip netns exec nat-router iptables -A FORWARD -s 10.10.70.10/32 -d 10.20.70.10/32 -p tcp --dport 80 -j ACCEPT
sudo ip netns exec nat-router iptables -t nat -A PREROUTING -i nc-r -p tcp --dport 8080 -j DNAT --to-destination 10.20.70.10:80
sudo ip netns exec nat-router iptables -t nat -A POSTROUTING -s 10.10.70.0/24 -o ns-r -j MASQUERADE
sudo ip netns exec nat-client curl -sI --max-time 3 http://10.10.70.1:8080 | head -5
```

## Verification Commands

Run these commands after applying the final configuration.

```bash
sudo ip netns list | grep -q "^nat-client\b" && sudo ip netns list | grep -q "^nat-router\b" && sudo ip netns list | grep -q "^nat-server\b"
sudo ip netns exec nat-router iptables -t nat -S PREROUTING | grep -q "--dport 8080.*DNAT.*10.20.70.10:80"
sudo ip netns exec nat-router sysctl -n net.ipv4.ip_forward | grep -q "^1$"
sudo ip netns exec nat-client curl -sI --max-time 2 http://10.10.70.1:8080 | grep -q "HTTP/1"
```

## Validation Checklist

- [ ] Namespaces exist
- [ ] DNAT rule exists
- [ ] Router forwarding enabled
- [ ] Port forward returns HTTP
- [ ] `labs/lab_07_nat_port_forwarding/validation_script.sh` reports `PASS` for all required checks
- [ ] Misconfiguration scenario has been tested and remediated
- [ ] Debugging walkthrough steps were performed in order

## Cleanup (Optional)

```bash
# Optional cleanup: remove nat-client/nat-router/nat-server namespaces and veth pairs.
```
