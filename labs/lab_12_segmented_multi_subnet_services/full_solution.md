# Lab 12: Segmented Multi-Subnet Services and Policy Enforcement - Full Solution

## Final Working Configuration

```bash
sudo ip netns exec s12-router iptables -F FORWARD
sudo ip netns exec s12-router iptables -P FORWARD DROP
sudo ip netns exec s12-router iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
sudo ip netns exec s12-router iptables -A FORWARD -s 10.12.10.0/24 -d 10.12.20.10/32 -p tcp --dport 8080 -j ACCEPT
sudo ip netns exec s12-router iptables -A FORWARD -s 10.12.20.10/32 -d 10.12.30.10/32 -p tcp --dport 5432 -j ACCEPT
sudo ip netns exec s12-client curl -sI --max-time 3 http://10.12.20.10:8080 | head -5
sudo ip netns exec s12-client nc -vz -w 2 10.12.30.10 5432 || true
```

## Verification Commands

```bash
sudo ip netns exec s12-router sysctl -n net.ipv4.ip_forward | grep -q "^1$"
sudo ip netns exec s12-client curl -sI --max-time 2 http://10.12.20.10:8080 | grep -q "HTTP/1"
sudo ip netns exec s12-app nc -z -w 2 10.12.30.10 5432
! sudo ip netns exec s12-client nc -z -w 2 10.12.30.10 5432
```

## Validation Checklist

- [ ] Router forwarding enabled
- [ ] Client reaches app HTTP
- [ ] App reaches DB 5432
- [ ] Client blocked from DB 5432
- [ ] `labs/lab_12_segmented_multi_subnet_services/validation_script.sh` returns `RESULT: PASS`
- [ ] Misconfiguration scenario reproduced and remediated
- [ ] Operational failure simulation triaged using evidence

## Cleanup (Optional)

```bash
# Optional cleanup: pkill http.server; pkill nc; delete s12-* namespaces
```
