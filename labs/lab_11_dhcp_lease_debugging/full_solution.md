# Lab 11: DHCP Lease Debugging with dnsmasq and dhclient - Full Solution

## Final Working Configuration

```bash
sed -i 's/10.12.0.100,10.12.0.120/10.11.0.100,10.11.0.120/' /tmp/dnsmasq-l11.conf || true
sudo ip netns exec dhcp11-server pkill -x dnsmasq || true
sudo ip netns exec dhcp11-server iptables -F INPUT || true
sudo ip netns exec dhcp11-server dnsmasq --conf-file=/tmp/dnsmasq-l11.conf >/tmp/dnsmasq-l11.log 2>&1 &
sleep 1
sudo ip netns exec dhcp11-client dhclient -r d11c-ns || true
sudo ip netns exec dhcp11-client dhclient -v d11c-ns
```

## Verification Commands

```bash
sudo ip netns list | grep -q "^dhcp11-client\b" && sudo ip netns list | grep -q "^dhcp11-server\b"
sudo ip netns exec dhcp11-client ip -o -4 addr show dev d11c-ns | grep -q "10.11.0."
sudo ip netns exec dhcp11-server ss -lunp | grep -q ":67"
ip link show br-l11 >/dev/null 2>&1
```

## Validation Checklist

- [ ] Namespaces exist
- [ ] Client has DHCP lease in 10.11.0.0/24
- [ ] dnsmasq listening on UDP/67
- [ ] Bridge br-l11 exists
- [ ] `labs/lab_11_dhcp_lease_debugging/validation_script.sh` returns `RESULT: PASS`
- [ ] Misconfiguration scenario reproduced and remediated
- [ ] Operational failure simulation triaged using evidence

## Cleanup (Optional)

```bash
# Optional cleanup: pkill dnsmasq; sudo ip netns del dhcp11-client; sudo ip netns del dhcp11-server; sudo ip link del br-l11 || true
```
