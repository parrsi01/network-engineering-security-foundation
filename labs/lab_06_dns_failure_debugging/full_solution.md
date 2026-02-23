# Lab 06: DNS Failure Debugging Workflow - Full Solution

## Final Working Configuration

The following commands restore or apply the validated end state for this lab.

```bash
# Final working DNS path
echo 'nameserver 10.60.6.53' | sudo tee /etc/netns/dns-client/resolv.conf >/dev/null
sudo ip netns exec dns-server iptables -F INPUT
sudo ip netns exec dns-client dig +short lab6.test
sudo ip netns exec dns-client getent hosts lab6.test
```

## Verification Commands

Run these commands after applying the final configuration.

```bash
sudo ip netns list | grep -q "^dns-client\b" && sudo ip netns list | grep -q "^dns-server\b"
test -f /etc/netns/dns-client/resolv.conf && grep -q "10.60.6.53" /etc/netns/dns-client/resolv.conf
sudo ip netns exec dns-server pgrep -x dnsmasq >/dev/null 2>&1
sudo ip netns exec dns-client dig +time=1 +tries=1 +short lab6.test | grep -q "10.60.6.100"
```

## Validation Checklist

- [ ] Namespaces exist
- [ ] Namespace resolv.conf points to lab DNS
- [ ] dnsmasq process is running in dns-server namespace
- [ ] DNS resolution succeeds
- [ ] `labs/lab_06_dns_failure_debugging/validation_script.sh` reports `PASS` for all required checks
- [ ] Misconfiguration scenario has been tested and remediated
- [ ] Debugging walkthrough steps were performed in order

## Cleanup (Optional)

```bash
# Optional cleanup: pkill dnsmasq; remove namespaces/bridge; remove `/etc/netns/dns-client/resolv.conf`.
```
