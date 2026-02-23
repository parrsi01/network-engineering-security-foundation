# Lab 04: Firewall Configuration with iptables/UFW on a Lab Router - Full Solution

## Final Working Configuration

The following commands restore or apply the validated end state for this lab.

```bash
# Final working filter policy
sudo ip netns exec fw-router iptables -F FORWARD
sudo ip netns exec fw-router iptables -P FORWARD DROP
sudo ip netns exec fw-router iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
sudo ip netns exec fw-router iptables -A FORWARD -s 10.10.40.10/32 -d 10.20.40.10/32 -p icmp -j ACCEPT
sudo ip netns exec fw-router iptables -A FORWARD -s 10.10.40.10/32 -d 10.20.40.10/32 -p tcp --dport 8080 -j ACCEPT
sudo ip netns exec fw-client curl -sI --max-time 3 http://10.20.40.10:8080 | head -5
```

## Verification Commands

Run these commands after applying the final configuration.

```bash
sudo ip netns list | grep -q "^fw-client\b" && sudo ip netns list | grep -q "^fw-router\b" && sudo ip netns list | grep -q "^fw-server\b"
sudo ip netns exec fw-router sysctl -n net.ipv4.ip_forward | grep -q "^1$"
sudo ip netns exec fw-router iptables -S FORWARD | head -1 | grep -q "-P FORWARD DROP"
sudo ip netns exec fw-client curl -sI --max-time 2 http://10.20.40.10:8080 | grep -q "HTTP/1"
```

## Validation Checklist

- [ ] Namespaces exist
- [ ] Router forwarding enabled
- [ ] FORWARD policy is DROP
- [ ] HTTP allowed through firewall
- [ ] `labs/lab_04_firewall_configuration/validation_script.sh` reports `PASS` for all required checks
- [ ] Misconfiguration scenario has been tested and remediated
- [ ] Debugging walkthrough steps were performed in order

## Cleanup (Optional)

```bash
# Optional cleanup: delete namespaces fw-client/fw-router/fw-server and related veth pairs if present.
```
