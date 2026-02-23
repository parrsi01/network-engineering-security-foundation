# Lab 14: OSPF (FRR) and VRRP (Keepalived) Control-Plane Review + VIP Failover Simulation - Full Solution

## Final Working Configuration

```bash
cp configs/sample_keepalived.conf /tmp/lab14-adv/keepalived.conf
sudo ip netns exec vrrp14-b ip addr del 10.14.0.254/24 dev v14b-ns 2>/dev/null || true
sudo ip netns exec vrrp14-a ip addr add 10.14.0.254/24 dev v14a-ns label v14a-ns:vip 2>/dev/null || true
sudo ip netns exec vrrp14-client ping -c 2 10.14.0.254
```

## Verification Commands

```bash
test -f configs/sample_frr_ospfd.conf
test -f configs/sample_keepalived.conf
sudo ip netns exec vrrp14-client ping -c 1 -W 1 10.14.0.254 >/dev/null 2>&1
ip link show br-l14 >/dev/null 2>&1
```

## Validation Checklist

- [ ] FRR sample config exists
- [ ] Keepalived sample config exists
- [ ] VIP reachable from client
- [ ] Bridge br-l14 exists
- [ ] `labs/lab_14_ospf_vrrp_control_plane_review/validation_script.sh` returns `RESULT: PASS`
- [ ] Misconfiguration scenario reproduced and remediated
- [ ] Operational failure simulation triaged using evidence

## Cleanup (Optional)

```bash
# Optional cleanup: delete vrrp14-* namespaces and br-l14; remove /tmp/lab14-adv
```
